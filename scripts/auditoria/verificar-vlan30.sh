#!/bin/bash
set -eu
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
tests=[('docker3','192.168.20.10','192.168.30.11',3306),('docker3','192.168.20.10','192.168.30.11',22),('docker3','192.168.20.10','192.168.30.11',33060),('docker3','10.177.0.2','10.177.0.3',3306),('docker6','192.168.10.125','192.168.20.10',443),('docker6','192.168.10.125','192.168.30.11',3306),('docker6','10.177.0.4','10.177.0.3',3306)]
for container,src,dst,port in tests:
 pid=subprocess.check_output(['docker','inspect','-f','{{.State.Pid}}',container]).decode().strip()
 subprocess.call(['nsenter','-t',pid,'-n','python3','-c',program,src,dst,str(port)])
subprocess.call(['python3','-c',program,'10.177.0.1','10.177.0.3','23'])
PY
docker exec docker6 curl --interface eth1 -k -sS --connect-timeout 5 --max-time 8 -w '\nUSER_HTTPS http=%{http_code}\n' https://192.168.20.10/
docker exec docker4 mysql -u root -e 'SELECT VERSION();'
docker exec docker4 ping -c 2 -W 2 192.168.30.1
