#!/bin/bash
python3 - <<'PY'
import telnetlib,time,re
t=telnetlib.Telnet('127.0.0.1',30002,8)
def read(sec=1):
    time.sleep(sec)
    return t.read_very_eager().decode('utf-8','replace')
out=read(1)
t.write(b'\r'); out+=read(1)
if re.search(r'(?i)(login:|username:)',out):
    t.write(b'admin\r'); out+=read(1)
if re.search(r'(?i)password:',out):
    t.write(b'admin\r'); out+=read(2)
for c in [
    b'execute log filter reset\r',
    b'execute log filter category 4\r',
    b'execute log filter field subtype ips\r',
    b'execute log display\r',
]:
    t.write(c); out+=read(2)
    if '--More--' in out[-2000:]:
        t.write(b' '); out+=read(1)
print(out)
t.close()
PY
