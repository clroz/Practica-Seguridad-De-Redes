#!/bin/bash
python3 - <<'PY'
import telnetlib,time,re
t=telnetlib.Telnet('127.0.0.1',30001,8)
def cmd(c,wait=1):
    t.write((c+'\r').encode()); time.sleep(wait)
    out=t.read_very_eager().decode('utf-8','replace')
    if '--More--' in out: t.write(b' '); time.sleep(.5); out+=t.read_very_eager().decode('utf-8','replace')
    return out
t.write(b'\r'); time.sleep(.5); print(t.read_very_eager().decode('utf-8','replace'))
for c in [
 'enable',
 'configure terminal',
 'ip dhcp snooping',
 'ip dhcp snooping vlan 10,20',
 'interface GigabitEthernet0/0',
 'ip dhcp snooping trust',
 'exit',
 'interface range GigabitEthernet0/1 , GigabitEthernet0/2 , GigabitEthernet0/3 , GigabitEthernet1/0',
 'switchport mode access',
 'switchport port-security',
 'switchport port-security maximum 2',
 'switchport port-security violation restrict',
 'switchport port-security mac-address sticky',
 'spanning-tree portfast',
 'spanning-tree bpduguard enable',
 'exit', 'end', 'write memory']:
 print(cmd(c,1))
for c in ['show port-security','show ip dhcp snooping','show spanning-tree summary']:
 print('=== '+c+' ==='); print(cmd(c,2))
t.close()
PY
