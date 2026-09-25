python3 - <<'PY'
import telnetlib,time
t=telnetlib.Telnet('127.0.0.1',30002,5)
t.write(b'\r')
time.sleep(.5)
print(t.read_very_eager().decode('utf8','replace'))
for cmd in [b'get system interface physical\r',b'get system interface port1\r',b'get router info routing-table all\r']:
 t.write(cmd)
 time.sleep(1)
 print(t.read_very_eager().decode('utf8','replace'))
t.close()
PY
