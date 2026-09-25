#!/bin/bash
set -eu
test "$(docker exec docker4 hostname)" = DB1
test "$(docker exec docker3 hostname)" = WEB1
docker exec docker3 ip route replace default via 192.168.20.1 dev eth1
python3 - <<'PY'
import os,secrets,subprocess,json
folder='/root/pnet-practica-secrets'
os.makedirs(folder,mode=0o700,exist_ok=True)
path=folder+'/webapp.json'
if os.path.exists(path):
 with open(path) as f: password=json.load(f)['password']
else:
 password=secrets.token_hex(24)
 fd=os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
 with os.fdopen(fd,'w') as f:json.dump({'password':password},f)
sql="""CREATE DATABASE IF NOT EXISTS practica CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'webapp'@'192.168.20.10' IDENTIFIED BY '%s';
GRANT SELECT, INSERT, UPDATE, DELETE ON practica.* TO 'webapp'@'192.168.20.10';
CREATE TABLE IF NOT EXISTS practica.productos (id INT PRIMARY KEY, nombre VARCHAR(100) NOT NULL, precio DECIMAL(10,2) NOT NULL);
INSERT IGNORE INTO practica.productos VALUES (1,'Producto de laboratorio',100.00),(2,'Servicio de prueba',250.00);
SHOW GRANTS FOR 'webapp'@'192.168.20.10';
SELECT id,nombre,precio FROM practica.productos;
""" % password
subprocess.run(['docker','exec','-i','docker4','mysql','-u','root'],input=sql.encode(),check=True)
cfg='[client]\nhost=192.168.30.11\nport=3306\nuser=webapp\npassword='+password+'\ndatabase=practica\nprotocol=tcp\n'
subprocess.run(['docker','exec','-i','docker3','sh','-c','umask 077; cat > /root/.my-practica.cnf'],input=cfg.encode(),check=True)
print('Credential stored privately on PNETLab and WEB1; not printed.')
PY
docker exec docker3 sh -c 'cat /etc/os-release; command -v mysql || true'
docker exec docker3 apt-get update
docker exec docker3 env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends mysql-client
