#!/bin/bash
set -u
test "$(hostname)" = pnetlab
docker exec docker4 service mysql stop >/dev/null 2>&1 || true
docker exec docker4 pkill -9 mysqld >/dev/null 2>&1 || true
apparmor_parser -R /etc/apparmor.d/usr.sbin.mysqld >/dev/null 2>&1 || true
docker exec docker4 service mysql start || true
sleep 2
docker exec docker4 sh -c 'ps -ef | grep [m]ysqld || true; ss -lntp | grep -E ":(3306|33060) " || true'
