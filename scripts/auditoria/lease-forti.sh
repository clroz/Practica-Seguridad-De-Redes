cat /var/lib/misc/dnsmasq.leases 2>/dev/null || true
cat /var/lib/dnsmasq/dnsmasq.leases 2>/dev/null || true
ip neigh show dev pnet0 | grep -E '50:|Forti' || true
