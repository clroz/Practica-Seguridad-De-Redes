#!/bin/bash
set -eu
test "$(hostname)" = pnetlab
test "$(docker exec docker3 hostname)" = WEB1
test "$(docker exec docker4 hostname)" = DB1

# Start the services after a node restart.
docker exec docker4 service mysql start || true
docker exec docker3 service apache2 start || true

# Server VLAN: 10.17.45.128/28, gateway 10.17.45.129.
docker exec docker3 ip address replace 10.17.45.130/28 dev eth1
docker exec docker3 ip route replace default via 10.17.45.129 dev eth1
docker exec docker4 ip address replace 10.17.45.131/28 dev eth1
docker exec docker4 ip route replace default via 10.17.45.129 dev eth1

# Users VLAN route for return traffic.
docker exec docker3 ip route replace 10.17.45.0/25 via 10.17.45.129 dev eth1
docker exec docker4 ip route replace 10.17.45.0/25 via 10.17.45.129 dev eth1

# Move the application account to the new WEB1 address and update its private client file.
docker exec docker4 mysql -u root <<'SQL'
SET @old_exists = (SELECT COUNT(*) FROM mysql.user WHERE User='webapp' AND Host='192.168.20.10');
SET @new_exists = (SELECT COUNT(*) FROM mysql.user WHERE User='webapp' AND Host='10.17.45.130');
SET @rename_sql = IF(@old_exists > 0 AND @new_exists = 0,
  "RENAME USER 'webapp'@'192.168.20.10' TO 'webapp'@'10.17.45.130'",
  'SELECT 1');
PREPARE rename_stmt FROM @rename_sql;
EXECUTE rename_stmt;
DEALLOCATE PREPARE rename_stmt;
FLUSH PRIVILEGES;
SQL
docker exec docker3 sed -i 's/^host=.*/host=10.17.45.131/' /root/.my-practica.cnf

echo '=== WEB1 ==='
docker exec docker3 ip -br -4 addr
docker exec docker3 ip route
echo '=== DB1 ==='
docker exec docker4 ip -br -4 addr
docker exec docker4 ip route
docker exec docker4 ss -lntp | grep -E ':(3306|33060) ' || true
