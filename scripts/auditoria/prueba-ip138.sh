for p in 80 443 22; do timeout 5 bash -c "</dev/tcp/192.168.22.138/$p" 2>/dev/null && echo "192.168.22.138 $p OPEN" || echo "192.168.22.138 $p FAIL"; done
curl -k -I --connect-timeout 5 --max-time 8 https://192.168.22.138 2>&1 | head -15
