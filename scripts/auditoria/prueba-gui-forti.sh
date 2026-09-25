curl -k -I --connect-timeout 5 --max-time 8 https://192.168.22.135 2>&1 | head -20
curl -k -I --connect-timeout 5 --max-time 8 https://192.168.22.132 2>&1 | head -12
python3 - <<'PY'
import socket
for ip in ['192.168.22.135','192.168.22.132']:
 for port in [80,443,22]:
  s=socket.socket();s.settimeout(5)
  try:s.connect((ip,port));print(ip,port,'OPEN')
  except Exception as e:print(ip,port,'ERROR',e)
  finally:s.close()
PY
