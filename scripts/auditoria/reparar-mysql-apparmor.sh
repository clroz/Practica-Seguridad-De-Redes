#!/bin/bash
set -eu
test "$(hostname)" = pnetlab
if command -v aa-complain >/dev/null 2>&1; then
  aa-complain /etc/apparmor.d/usr.sbin.mysqld || true
elif command -v apparmor_parser >/dev/null 2>&1; then
  apparmor_parser -C -r /etc/apparmor.d/usr.sbin.mysqld || true
fi
docker exec docker4 service mysql start || true
docker exec docker4 sh -c 'service mysql status || true; ss -lntp | grep -E ":(3306|33060) " || true'
