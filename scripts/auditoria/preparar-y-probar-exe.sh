#!/bin/bash
echo 'LAB EXE TEST' > /tmp/lab.exe
docker cp /tmp/lab.exe docker3:/var/www/html/lab.exe
echo '=== DESCARGA EXE DESDE USR1 ==='
docker exec docker6 sh -c "curl -i --connect-timeout 5 --max-time 10 http://10.17.45.130/lab.exe" || true
