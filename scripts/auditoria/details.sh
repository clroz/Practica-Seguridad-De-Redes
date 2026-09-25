python3 - <<'PY'
import xml.etree.ElementTree as E
p='/opt/unetlab/labs/Practica Seguridad De Redes.unl'
r=E.parse(p).getroot()
print('LAB', {k:v for k,v in r.attrib.items() if k in ['name','id','version']})
for n in r.findall('.//node'):
 print('NODE', {k:v for k,v in n.attrib.items() if k in ['id','name','type','template','image','console','ethernet','ram']})
 for i in n.findall('interface'): print(' INTERFACE',dict(i.attrib))
for n in r.findall('.//network'): print('NETWORK',dict(n.attrib))
PY
docker inspect --format '{{.Name}} privileged={{.HostConfig.Privileged}} apparmor={{.AppArmorProfile}} pid={{.State.Pid}} mounts={{json .Mounts}}' docker3 docker4 docker6
docker exec docker3 sh -c 'hostname; ip -br -4 addr; ip route; ss -lntp; ps -eo comm; ls -l /var/www/html; cat /etc/network/interfaces'
docker exec docker4 sh -c 'hostname; ip -br -4 addr; ip route; ss -lntp; mysql -u root -e "SELECT VERSION(); SHOW DATABASES; SELECT User,Host,plugin FROM mysql.user;"; cat /etc/network/interfaces'
ps -eo pid,args | grep -E '[q]emu|[i]ou|[d]ynamips|[t]elnet|[u]noconv'
ss -lntp
