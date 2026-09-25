echo '=== WEB1 IP/RUTA ==='
docker exec docker3 ip -br -4 addr; docker exec docker3 ip route
echo '=== PING WEB1->DB1 ==='
docker exec docker3 ping -c 2 -W 2 10.17.45.131 || true
echo '=== TCP WEB1->DB1 ==='
docker exec docker3 sh -c 'nc -vz -w 3 10.17.45.131 3306 || true'
echo '=== DB1 SOCKETS/FIREWALL ==='
docker exec docker4 ss -lntp; docker exec docker4 iptables -S INPUT 2>/dev/null || true
