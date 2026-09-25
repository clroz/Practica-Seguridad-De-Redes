#!/bin/bash
python3 - <<'PY'
import telnetlib,time,re
t=telnetlib.Telnet('127.0.0.1',30002,8)
def read(seconds=5):
 time.sleep(seconds); return t.read_very_eager().decode('utf8','replace')
out=read(); t.write(b'\r'); out+=read()
if re.search(r'(?i)(login:|username:)',out): t.write(b'admin\r'); out+=read()
if re.search(r'(?i)password:',out): t.write(b'admin\r'); out+=read()
for c in [b'get system status\r',b'get system interface physical\r']:
 t.write(c); out+=read(5)
print(out); t.close()
PY
