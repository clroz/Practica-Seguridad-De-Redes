ps -eo pid,etime,stat,args | grep -E '[q]emu-system.*Fortinet|[q]emu_wrapper_telnet.*Fortinet' || true
ss -lntp | grep -E ':(30002|443|80) ' || true
python3 - <<'PY'
import socket
for port in [30002]:
 s=socket.socket();s.settimeout(3)
 try:s.connect(('127.0.0.1',port));print('fortigate console reachable',port)
 except Exception as e:print('console error',e)
 finally:s.close()
PY
curl -k -I --connect-timeout 3 --max-time 5 https://192.168.22.132 2>&1 | head -12
