echo '=== USUARIO GRAFICO docker6 ==='
docker exec docker6 sh -c 'hostname; hostname -I 2>/dev/null || true; ifconfig 2>/dev/null || true; route -n 2>/dev/null || true; cat /etc/resolv.conf'
echo '=== CONSOLAS PNET ==='
ss -lntp | grep -E ':3000[3456] ' || true
