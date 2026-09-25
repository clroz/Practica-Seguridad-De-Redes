echo '=== COMANDOS ==='
command -v aa-status || true
command -v aa-complain || true
command -v apparmor_parser || true
echo '=== PERFIL CARGADO ==='
cat /sys/kernel/security/apparmor/profiles 2>/dev/null | grep -E 'mysqld|usr.sbin' || true
echo '=== ESTADO ==='
aa-status 2>&1 | head -30 || true
echo '=== ARCHIVO ==='
ls -l /etc/apparmor.d/usr.sbin.mysqld 2>/dev/null || true
