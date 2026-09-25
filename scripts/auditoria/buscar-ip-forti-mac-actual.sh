mac=$(ps -eo args | grep 'name Fortinet' | grep -o 'mac=[^,]*' | head -1 | cut -d= -f2)
echo "MAC=$mac"
ip neigh show | grep -i "${mac}" || true
echo '=== CANDIDATOS REACHABLE ==='
ip neigh show nud reachable nud stale nud delay | head -30
