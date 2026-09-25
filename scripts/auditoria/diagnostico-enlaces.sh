echo '=== LINKS WEB1/DB1 EN HOST ==='
ip -d link show vunl3_0 vunl3_1 vunl4_0 vunl4_1 2>&1 || true
echo '=== BRIDGES ==='
bridge link show 2>/dev/null | grep -E 'vunl3|vunl4|veth' || true
echo '=== NAMESPACES DE CONTENEDORES ==='
for c in docker3 docker4; do
  p=$(docker inspect -f '{{.State.Pid}}' "$c" 2>/dev/null || true)
  echo "$c pid=$p"
  if [ -n "$p" ] && [ "$p" != 0 ]; then nsenter -t "$p" -n ip -d link show; fi
done
