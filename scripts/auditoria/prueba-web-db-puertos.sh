for port in 22 33060; do
  echo "=== WEB1 -> DB1:$port ==="
  docker exec docker3 sh -c "curl --connect-timeout 3 --max-time 5 telnet://10.17.45.131:$port" >/tmp/webdb.out 2>&1
  rc=$?
  cat /tmp/webdb.out
  if [ "$rc" -eq 0 ]; then echo 'RESULTADO: OPEN'; else echo "RESULTADO: BLOCKED (curl rc=$rc)"; fi
done
