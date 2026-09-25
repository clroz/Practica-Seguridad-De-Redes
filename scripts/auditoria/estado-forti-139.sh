ps -eo pid,etime,stat,args | grep -E '[q]emu-system.*Fortinet|[q]emu_wrapper_telnet.*Fortinet' || true
python3 - <<'PY'
import socket,subprocess
ip='192.168.22.139'
for p in [22,80,443]:
 s=socket.socket();s.settimeout(3)
 try:s.connect((ip,p));print(ip,p,'OPEN')
 except Exception as e:print(ip,p,'ERROR',e)
 finally:s.close()
subprocess.run(['ping','-c','3','-W','1',ip])
PY
