docker exec docker6 sh -c 'echo ===RUTAS===; route -n; echo ===PING-GW===; ping -c 2 -W 2 10.17.45.1 || true; echo ===PING-WEB===; ping -c 2 -W 2 10.17.45.130 || true'
