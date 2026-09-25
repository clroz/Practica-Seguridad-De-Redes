hostname
uptime
docker ps --format '{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}'
find /opt/unetlab/labs -maxdepth 4 -type f -name '*.unl' -printf '%TY-%Tm-%Td %TH:%TM %p\n'
ip -br -4 addr
