python3 -u - <<'PY'
import telnetlib,time,re
t=telnetlib.Telnet('127.0.0.1',30002,5);t.write(b'\r');time.sleep(.4)
initial=t.read_very_eager().decode('utf8','replace');print('PROMPT',initial)
if not re.search(r'FortiGate-VM64-KVM #\s*$',initial):
 print('PENDING: authenticated root-level console required.');t.close();raise SystemExit(0)
for cmd in ['get system status','show system interface','get router info routing-table all','show system dhcp server','show firewall address','show firewall policy','show firewall DoS-policy','show firewall vip']:
 print('COMMAND',cmd,flush=True);t.write((cmd+'\r').encode());out='';deadline=time.time()+15
 while time.time()<deadline:
  time.sleep(.15);s=t.read_very_eager().decode('utf8','replace');out+=s
  if '--More--' in s:t.write(b' ')
  if re.search(r'FortiGate-VM64-KVM #\s*$',out):break
 for line in out.splitlines():
  print('[REDACTED credential line]' if re.search(r'(?i)\b(password|secret|private-key|psksecret)\b',line) else line)
t.close()
PY
