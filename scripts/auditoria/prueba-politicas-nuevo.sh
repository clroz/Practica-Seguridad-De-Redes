echo '=== HTTPS NORMAL USUARIO -> WEB1 ==='
docker exec docker6 sh -c 'curl -k -i --connect-timeout 5 --max-time 10 https://10.17.45.130/' || true
echo '=== SQLi USUARIO -> WEB1 ==='
docker exec docker6 sh -c "curl -k -i --connect-timeout 5 --max-time 10 'https://10.17.45.130/index.php?fid=1%27%20OR%20%271%27=%271'" || true
echo '=== PUERTO DB DESDE USUARIO ==='
docker exec docker6 sh -c 'timeout 5 sh -c "cat </dev/null >/dev/tcp/10.17.45.131/3306"' && echo OPEN || echo BLOCKED
