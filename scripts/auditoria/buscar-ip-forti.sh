for i in $(seq 1 254); do ping -c 1 -W 1 192.168.22.$i >/dev/null 2>&1 & done
wait
ip neigh show dev pnet0
