docker exec docker6 sh -c 'ip -4 addr; ip route; ping -c 2 -W 2 192.168.10.1 || true; curl -k -i --connect-timeout 5 --max-time 10 https://192.168.20.10/'
