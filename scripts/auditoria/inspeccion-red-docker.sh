echo '=== INSPECT DOCKER3 ==='
docker inspect --format 'Name={{.Name}} State={{.State.Status}} Pid={{.State.Pid}} Networks={{json .NetworkSettings.Networks}}' docker3
echo '=== INSPECT DOCKER4 ==='
docker inspect --format 'Name={{.Name}} State={{.State.Status}} Pid={{.State.Pid}} Networks={{json .NetworkSettings.Networks}}' docker4
echo '=== INTERFACES EN HOST ==='
ip -br link show | grep -E 'vunl|veth|docker' || true
echo '=== PUERTOS DE CONSOLA ==='
ss -lntp | grep -E ':3000[34] ' || true
