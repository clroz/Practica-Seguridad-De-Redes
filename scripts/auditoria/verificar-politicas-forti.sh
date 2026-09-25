#!/bin/bash
python3 - <<'PY'
import telnetlib,time,re
t=telnetlib.Telnet('127.0.0.1',30002,8)
def read(sec=1):
    time.sleep(sec); return t.read_very_eager().decode('utf-8','replace')
out=read(); t.write(b'\r'); out+=read()
if re.search(r'(?i)(login:|username:)',out): t.write(b'admin\r'); out+=read()
if re.search(r'(?i)password:',out): t.write(b'admin\r'); out+=read(2)
t.write(b'show firewall policy\r'); out+=read(4)
print(out); t.close()
PY
