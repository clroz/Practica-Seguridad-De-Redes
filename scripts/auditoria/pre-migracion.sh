docker inspect --format '{{.Name}} Entrypoint={{json .Config.Entrypoint}} Cmd={{json .Config.Cmd}}' docker3 docker4 docker6
docker exec docker4 sh -c 'ls -la /; ls -l /etc/rc.local /etc/init.d/rcS /etc/init.d/mysql /etc/mysql/mysql.conf.d/mysqld.cnf 2>/dev/null; command -v iptables; command -v ip; cat /etc/rc.local 2>/dev/null'
docker exec docker4 ip -4 addr show
docker exec docker4 ip -4 route show
docker exec docker3 ip -4 route show
nsenter -t $(docker inspect -f '{{.State.Pid}}' docker6) -n ip -4 route show
nsenter -t $(docker inspect -f '{{.State.Pid}}' docker4) -n iptables-save
python3 -u - <<'PY'
import telnetlib,time,re
t=telnetlib.Telnet('127.0.0.1',30001,5);t.write(b'\r');time.sleep(.4)
start=t.read_very_eager().decode('utf8','replace');prefix='do ' if '(config' in start else ''
print('PROMPT',start)
if re.search(r'Switch>\s*$',start):
 t.write(b'enable\r');time.sleep(.5);start=t.read_very_eager().decode('utf8','replace')
if not re.search(r'Switch(?:\([^\r\n]*\))?#\s*$',start):
 print('Switch requires privileged session');raise SystemExit(1)
for cmd in ['show running-config','show startup-config','show vlan brief','show interfaces trunk']:
 print('COMMAND',cmd,flush=True);t.write((prefix+cmd+'\r').encode());out='';end=time.time()+20
 while time.time()<end:
  time.sleep(.1);s=t.read_very_eager().decode('utf8','replace');out+=s
  if '--More--' in s:t.write(b' ')
  if re.search(r'Switch(?:\([^\r\n]*\))?#\s*$',out):break
 print('\n'.join('[credential omitted]' if re.search(r'(?i)\b(secret|password|community)\b',line) else line for line in out.splitlines()),flush=True)
t.close()
PY
