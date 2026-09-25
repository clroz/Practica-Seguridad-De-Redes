#!/bin/bash
set -u
pid=$(docker inspect -f '{{.State.Pid}}' docker4)
test "$pid" -gt 1
ipt=/sbin/iptables
nsenter -t "$pid" -n "$ipt" -C INPUT -i eth1 -p tcp -s 10.17.45.130 --dport 3306 -j ACCEPT 2>/dev/null || nsenter -t "$pid" -n "$ipt" -I INPUT 1 -i eth1 -p tcp -s 10.17.45.130 --dport 3306 -j ACCEPT
nsenter -t "$pid" -n "$ipt" -C INPUT -i eth1 -j DROP 2>/dev/null || nsenter -t "$pid" -n "$ipt" -I INPUT 2 -i eth1 -j DROP
nsenter -t "$pid" -n "$ipt" -S INPUT
