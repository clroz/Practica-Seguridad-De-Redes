docker exec docker4 sh -c 'echo ===STATUS===; service mysql status || true; echo ===PROCESOS===; ps -ef | grep [m]ysqld || true; echo ===ERROR LOG===; tail -80 /var/log/mysql/error.log 2>/dev/null || tail -80 /var/log/mysql.err 2>/dev/null || true; echo ===DIR RUN===; ls -la /var/run/mysqld /run/mysqld 2>/dev/null || true'
dmesg | grep -Ei 'apparmor|mysqld|mysql' | tail -20 || true
