echo '=== CONTENEDORES ==='
docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}'
echo '=== PROCESOS APT ==='
ps -eo pid,etime,stat,args | grep -E '[a]pt|[d]pkg' || true
echo '=== DB1 ==='
docker exec docker4 sh -c 'hostname; ip -br -4 addr; ip route; ss -lntp | grep -E ":(3306|33060)" || true; mysql -u root -e "SELECT VERSION(); SHOW DATABASES; SHOW GRANTS FOR \"webapp\"@\"192.168.20.10\"; USE practica; SELECT * FROM productos;"'
echo '=== WEB1 ==='
docker exec docker3 sh -c 'hostname; ip -br -4 addr; ip route; command -v mysql || true; test -f /root/.my-practica.cnf && echo credential-file-present || true; ss -lntp | grep -E ":(80|443)" || true'
echo '=== TCP ==='
python3 - <<'PY'
import subprocess
code='''import socket,sys
s=socket.socket();s.settimeout(3)
try:s.bind((sys.argv[1],0));s.connect((sys.argv[2],int(sys.argv[3])));print("OPEN",sys.argv[1],sys.argv[2],sys.argv[3])
except Exception as e:print("BLOCKED",sys.argv[1],sys.argv[2],sys.argv[3],e)
finally:s.close()
'''
for c,a,b,p in [('docker3','192.168.20.10','192.168.30.11','3306'),('docker3','192.168.20.10','192.168.30.11','22'),('docker6','192.168.10.125','192.168.20.10','443'),('docker6','192.168.10.125','192.168.30.11','3306')]:
 pid=subprocess.check_output(['docker','inspect','-f','{{.State.Pid}}',c]).decode().strip();subprocess.run(['nsenter','-t',pid,'-n','python3','-c',code,a,b,p])
PY
