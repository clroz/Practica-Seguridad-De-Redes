pid=$(docker inspect -f '{{.State.Pid}}' docker4)
echo ===IPTABLES===
nsenter -t "$pid" -n /sbin/iptables-save 2>&1 || true
echo ===NFT===
nsenter -t "$pid" -n /usr/sbin/nft list ruleset 2>&1 || true
echo ===TABLES===
nsenter -t "$pid" -n cat /proc/net/ip_tables_names 2>&1 || true
