#!/bin/bash
set -u
systemctl stop apparmor 2>/dev/null || true
docker exec docker4 service mysql stop >/dev/null 2>&1 || true
docker exec docker4 pkill -9 mysqld >/dev/null 2>&1 || true
docker exec docker4 rm -f /run/mysqld/* /var/lib/mysql/DB1.pid
docker exec docker4 service mysql start
sleep 3
docker exec docker4 mysql --protocol=TCP --host=10.17.45.131 --port=3306 --connect-timeout=5 -u root -e 'SELECT VERSION();'
