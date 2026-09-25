docker inspect --format '{{.Name}} id={{.Id}} image={{.Config.Image}} restart={{.HostConfig.RestartPolicy.Name}} labels={{json .Config.Labels}}' docker3 docker4 docker6
ls -la /opt/unetlab/tmp/1/3 /opt/unetlab/tmp/1/4 /opt/unetlab/tmp/1/6
grep -nE 'startup|config|eth1|docker (run|start|commit)|CMD|entrypoint' /opt/unetlab/wrappers/docker_wrapper 2>/dev/null | head -60
docker exec docker4 sh -c 'ls -la /home; cat /home/start.sh; ls /etc/mysql/mysql.conf.d'
docker exec docker3 sh -c 'command -v mysql; command -v python3; command -v php; cat /home/start.sh'
ls -l /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/local/usr.sbin.mysqld
head -30 /etc/apparmor.d/usr.sbin.mysqld
df -h /opt/unetlab
