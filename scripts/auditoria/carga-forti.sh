ps -p $(pgrep -f 'qemu-system.*Fortinet' | head -1) -o pid,%cpu,%mem,etime,args
free -m
df -h /opt/unetlab
