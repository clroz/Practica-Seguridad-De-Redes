#!/bin/bash
python3 - <<'PY'
import telnetlib,time,re
t=telnetlib.Telnet('127.0.0.1',30002,8)
def read():
    time.sleep(1)
    return t.read_very_eager().decode('utf-8','replace')
out=read()
t.write(b'\r'); out+=read()
if re.search(r'(?i)(login:|username:)',out):
    t.write(b'admin\r'); out+=read()
if re.search(r'(?i)password:',out):
    t.write(b'admin\r'); out+=read()
t.write(b'diagnose test application httpsd 99\r')
out+=read()
print(out)
t.close()
PY
