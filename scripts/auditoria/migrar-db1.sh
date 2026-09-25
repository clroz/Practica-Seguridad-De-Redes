#!/bin/bash
# Applies the approved DB1 migration. Run ONLY on the identified PNETLab host.
# Runtime container network settings must be preserved/reapplied before recreation.
set -eu
test "$(hostname)" = pnetlab
test "$(docker exec docker4 hostname)" = DB1
test "$(docker exec docker3 hostname)" = WEB1
python3 -u - <<'PY'
import telnetlib,time,re
t=telnetlib.Telnet('127.0.0.1',30001,5)
def cmd(c):
 t.write((c+'\r').encode());out='';end=time.time()+15
 while time.time()<end:
  time.sleep(.1);s=t.read_very_eager().decode('utf8','replace');out+=s
  if re.search(r'Switch(?:\([^\r\n]*\))?[#>]\s*$',out):break
 print(out,flush=True)
 if re.search(r'% (?:Invalid|Incomplete|Ambiguous|Error)',out):raise RuntimeError('Switch rejected command')
 if not re.search(r'Switch(?:\([^\r\n]*\))?[#>]\s*$',out):raise RuntimeError('Switch prompt timeout')
 return out
start=cmd('')
if 'Switch>' in start:cmd('enable')
if '(config' in start:cmd('end')
for c in ['configure terminal','vlan 30','name DATABASE','exit','interface GigabitEthernet0/0','switchport trunk allowed vlan add 30','exit','interface GigabitEthernet0/3','switchport mode access','switchport access vlan 30','exit','end','write memory']:
 cmd(c)
t.close()
PY
docker exec docker4 ip address replace 192.168.30.11/28 dev eth1
if docker exec docker4 ip -4 address show dev eth1 | grep -q '192.168.20.11/28'; then
 docker exec docker4 ip address del 192.168.20.11/28 dev eth1
fi
docker exec docker4 ip route replace default via 192.168.30.1 dev eth1
if docker exec docker4 ip route show default | grep -q 'via 10.177.0.1'; then
 docker exec docker4 ip route del default via 10.177.0.1 dev eth0
fi
docker exec docker4 ip route replace 192.168.10.0/25 via 192.168.30.1 dev eth1
docker exec docker4 ip route replace 192.168.20.0/28 via 192.168.30.1 dev eth1
docker exec docker3 ip route replace 192.168.30.0/28 via 192.168.20.1 dev eth1
user_pid=$(docker inspect -f '{{.State.Pid}}' docker6)
db_pid=$(docker inspect -f '{{.State.Pid}}' docker4)
test "$user_pid" -gt 1
test "$db_pid" -gt 1
nsenter -t "$user_pid" -n ip route replace 192.168.30.0/28 via 192.168.10.1 dev eth1
# Only DB1's network namespace is changed. Permit its host-side administration.
if ! nsenter -t "$db_pid" -n iptables -C INPUT -i eth0 ! -s 10.177.0.1/32 -j DROP 2>/dev/null; then
 nsenter -t "$db_pid" -n iptables -I INPUT 1 -i eth0 ! -s 10.177.0.1/32 -j DROP
fi
docker exec docker4 ip -br -4 addr
docker exec docker4 ip route
nsenter -t "$db_pid" -n iptables -S INPUT
