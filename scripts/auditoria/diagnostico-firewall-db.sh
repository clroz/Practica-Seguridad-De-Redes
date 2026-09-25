pid=$(docker inspect -f '{{.State.Pid}}' docker4)
echo "DBPID=$pid"
nsenter -t "$pid" -n iptables-save 2>&1 || true
docker exec docker3 sh -c 'grep -E "^(host|user|database|protocol)=" /root/.my-practica.cnf || true'
