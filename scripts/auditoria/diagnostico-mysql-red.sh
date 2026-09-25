docker exec docker4 sh -c 'echo IPTABLES; iptables -L INPUT -n -v --line-numbers; echo MYSQLCFG; grep -RniE "bind-address|skip-networking|require_secure_transport|port" /etc/mysql 2>/dev/null; echo LOGS; tail -50 /var/log/mysql/error.log 2>/dev/null || true; tail -50 /var/log/mysql/error.log 2>/dev/null || true'
docker exec docker3 sh -c 'echo CONFIG; sed -n "1,20p" /root/.my-practica.cnf; echo ROUTE; ip route get 192.168.30.11'
docker exec docker4 sh -c 'echo SOCKET; mysqladmin -u root status; echo LISTEN; ss -lntp | grep 3306'
