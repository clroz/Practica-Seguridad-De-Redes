python3 - <<'PY'
import telnetlib,time
t=telnetlib.Telnet('127.0.0.1',30002,8)
def rd(label):
 time.sleep(2)
 d=t.read_very_eager().decode('utf8','replace')
 print(label,repr(d),flush=True)
 return d
out=rd('initial')
if 'login:' in out:
 t.write(b'admin\r');rd('after-user')
 t.write(b'admin\r');rd('after-pass')
 t.write(b'get system interface physical\r');rd('after-command')
t.close()
PY
