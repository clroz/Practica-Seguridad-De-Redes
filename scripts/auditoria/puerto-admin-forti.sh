python3 - <<'PY'
import telnetlib,time
t=telnetlib.Telnet('127.0.0.1',30002,5);t.write(b'\r');time.sleep(.4);t.read_very_eager()
for c in [b'show system global\r',b'show system interface port1\r']:
 t.write(c);time.sleep(1);print(t.read_very_eager().decode('utf8','replace'))
t.close()
PY
