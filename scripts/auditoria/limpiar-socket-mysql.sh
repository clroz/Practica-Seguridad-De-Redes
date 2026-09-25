#!/bin/bash
set -u
docker exec docker4 pkill -9 mysqld >/dev/null 2>&1 || true
docker exec docker4 rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.sock.lock /run/mysqld/mysqlx.sock /run/mysqld/mysqlx.sock.lock /var/lib/mysql/DB1.pid
docker exec docker4 service mysql start || true
sleep 3
docker exec docker4 sh -c 'service mysql status || true; ss -lntp | grep -E ":(3306|33060) " || true'
