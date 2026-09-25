#!/bin/bash
set -eu
docker exec docker6 ifconfig eth1 10.17.45.20 netmask 255.255.255.128 up
docker exec docker6 route del default >/dev/null 2>&1 || true
docker exec docker6 route add default gw 10.17.45.1 dev eth1
docker exec docker6 sh -c 'ifconfig eth1; route -n'
