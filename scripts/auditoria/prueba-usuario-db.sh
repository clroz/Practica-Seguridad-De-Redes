echo '=== USUARIO -> DB1:3306 ==='
docker exec docker6 sh -c 'curl --connect-timeout 3 --max-time 5 telnet://10.17.45.131:3306' >/tmp/dbtest.out 2>&1
rc=$?
cat /tmp/dbtest.out
if [ "$rc" -eq 0 ]; then echo 'RESULTADO: OPEN'; else echo "RESULTADO: BLOCKED (curl rc=$rc)"; fi
