python3 - <<'PY'
import telnetlib,time
t=telnetlib.Telnet('127.0.0.1',30002,5);t.write(b'\r');time.sleep(.4);t.read_very_eager()
for c in [b'show full-configuration system global\r',b'diagnose sys tcpsock | grep -E "(:443|:80)"\r']:
 t.write(c);time.sleep(1);out=t.read_very_eager().decode('utf8','replace');print(out)
t.close()
PY
