python3 - <<'PY'
import telnetlib,time
for port in [30001,30002]:
 print('CONSOLE',port)
 t=telnetlib.Telnet('127.0.0.1',port,5)
 t.write(b'\r\n')
 time.sleep(1)
 print(t.read_very_eager().decode('utf8','replace'))
 t.close()
PY
docker exec docker6 sh -c 'hostname; ip -br -4 addr; ip route; cat /etc/resolv.conf; ls /var/lib/dhcp; command -v curl; command -v python3'
docker exec docker3 sh -c 'apache2ctl -S; apache2ctl -M; cat /var/www/html/index.html; ls -l /etc/apache2/sites-enabled; ip route get 192.168.20.11; ip route get 10.177.0.3'
cat /sys/kernel/security/apparmor/profiles | grep -E 'mysqld|docker' || true
bridge link
