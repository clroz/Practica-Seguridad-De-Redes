python3 - <<'PY'
import telnetlib,time,re
t=telnetlib.Telnet('127.0.0.1',30001,5)
t.write(b'\r\n');time.sleep(.4)
initial=t.read_very_eager().decode('utf8','replace')
prefix='do ' if '(config' in initial else ''
print('PROMPT',initial)
for cmd in ['show vlan brief','show interfaces trunk','show interfaces status','show running-config','show startup-config','show port-security','show ip dhcp snooping','show spanning-tree summary']:
 print('\nCOMMAND',cmd)
 t.write((prefix+cmd+'\r\n').encode())
 out='';deadline=time.time()+15
 while time.time()<deadline:
  time.sleep(.15)
  s=t.read_very_eager().decode('utf8','replace');out+=s
  if '--More--' in s:t.write(b' ')
  if re.search(r'Switch(?:\([^\r\n]*\))?[#>]\s*$',out):break
 out='\n'.join('[REDACTED credential line]' if re.search(r'(?i)\b(secret|password|community)\b',line) else line for line in out.splitlines())
 print(out)
t.close()
PY
nsenter -t $(docker inspect -f '{{.State.Pid}}' docker6) -n ip -br -4 addr
nsenter -t $(docker inspect -f '{{.State.Pid}}' docker6) -n ip route
docker exec docker6 sh -c 'ps -ef | grep -E "[d]hcp|[c]hrom"; ls -l /etc/network; cat /etc/network/interfaces 2>/dev/null'
