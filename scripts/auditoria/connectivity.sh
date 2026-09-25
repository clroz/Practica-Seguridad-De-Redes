python3 -u - <<'PY'
import subprocess
program='''import socket,sys
source,target,port=sys.argv[1],sys.argv[2],int(sys.argv[3])
s=socket.socket();s.settimeout(3)
try:
 s.bind((source,0));s.connect((target,port));print(source+' -> '+target+':'+str(port)+' TCP OPEN')
except Exception as e:print(source+' -> '+target+':'+str(port)+' '+str(e))
finally:s.close()
'''
tests=[('docker3','192.168.20.10','192.168.20.11',3306),('docker3','192.168.20.10','192.168.20.11',22),('docker3','10.177.0.2','10.177.0.3',3306),('docker6','192.168.10.125','192.168.20.10',443),('docker6','192.168.10.125','192.168.20.11',3306),('docker6','10.177.0.4','10.177.0.3',3306)]
for container,src,dst,port in tests:
 pid=subprocess.check_output(['docker','inspect','-f','{{.State.Pid}}',container]).decode().strip()
 subprocess.call(['nsenter','-t',pid,'-n','python3','-c',program,src,dst,str(port)])
PY
docker exec docker3 curl -k -sS --connect-timeout 3 --max-time 5 -w '\nWEB_LOCAL_HTTPS http=%{http_code}\n' https://127.0.0.1/
nsenter -t $(docker inspect -f '{{.State.Pid}}' docker6) -n ip neigh
docker exec docker3 ip neigh
ip neigh show dev pnet0
python3 -u - <<'PY'
import telnetlib,time
t=telnetlib.Telnet('127.0.0.1',30002,5);t.write(b'\r');time.sleep(.4)
print('FORTIGATE PROMPT',t.read_very_eager().decode('utf8','replace'));t.close()
PY
