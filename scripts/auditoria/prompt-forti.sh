python3 - <<'PY'
import telnetlib,time
t=telnetlib.Telnet('127.0.0.1',30002,5)
t.write(b'\r\n')
time.sleep(1)
print(repr(t.read_very_eager().decode('utf8','replace')))
t.close()
PY
