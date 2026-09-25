#!/bin/bash
python3 - <<'PY'
import telnetlib,time,re
t=telnetlib.Telnet('127.0.0.1',30001,8)
t.write(b'\r'); time.sleep(.5); t.read_very_eager()
t.write(b'enable\r'); time.sleep(.3); t.read_very_eager()
t.write(b'terminal length 0\r'); time.sleep(.3); t.read_very_eager()
t.write(b'show running-config\r'); time.sleep(3)
out=t.read_very_eager().decode('utf-8','replace')
out=re.sub(r'(?im)^.*(?:enable secret|password|secret).*$','[REDACTED credential line]',out)
print(out)
t.close()
PY
