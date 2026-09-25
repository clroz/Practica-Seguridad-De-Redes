python3 -u - <<'PY'
import telnetlib,time,re
def query(t,cmd,prompt):
 t.write((cmd+'\r').encode());out='';end=time.time()+12
 while time.time()<end:
  time.sleep(.15);s=t.read_very_eager().decode('utf8','replace');out+=s
  if '--More--' in s:t.write(b' ')
  if re.search(prompt,out):break
 return '\n'.join('[REDACTED credential line]' if re.search(r'(?i)\b(secret|password|community)\b',line) else line for line in out.splitlines())
t=telnetlib.Telnet('127.0.0.1',30001,5);t.write(b'\r');time.sleep(.5)
start=t.read_very_eager().decode('utf8','replace');prefix='do ' if '(config' in start else ''
for cmd in ['show running-config','show startup-config']:
 print('COMMAND',cmd,flush=True);print(query(t,prefix+cmd,r'Switch(?:\([^\r\n]*\))?[#>]\s*$'),flush=True)
t.close()
t=telnetlib.Telnet('127.0.0.1',30002,5);t.write(b'\r');time.sleep(.5)
start=t.read_very_eager().decode('utf8','replace');print('FORTIGATE PROMPT',start,flush=True)
if re.search(r'FortiGate[^\r\n]*#\s*$',start):
 for cmd in ['get system status','show system interface','get router info routing-table all','show system dhcp server','show firewall address','show firewall policy','show firewall DoS-policy','show firewall vip']:
  print('COMMAND',cmd,flush=True);print(query(t,cmd,r'FortiGate[^\r\n]*#\s*$'),flush=True)
t.close()
PY
docker exec docker6 curl --interface eth1 -k -sS --connect-timeout 3 --max-time 5 -o /dev/null -w 'USER_TO_WEB_HTTPS http=%{http_code}\n' https://192.168.20.10/
docker exec docker6 python3 - <<'PY'
PY
