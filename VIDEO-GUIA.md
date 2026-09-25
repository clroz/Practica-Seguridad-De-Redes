# Guion del video demostrativo

Duración recomendada: 8 a 12 minutos.

## 1. Presentación e infraestructura

Mostrar la topología de PNETLab y explicar:

- FortiGate como firewall y gateway.
- SW1 como switch de acceso y trunk 802.1Q.
- VLAN 10 para usuarios.
- VLAN 20 para servidores.
- WEB1 como servidor HTTPS.
- DB1 como servidor MySQL.
- USR1 como equipo de pruebas.

## 2. Direccionamiento y segmentación

Mostrar en el README o en la GUI:

- VLAN 10: `10.17.45.0/25`, gateway `10.17.45.1`.
- VLAN 20: `10.17.45.128/28`, gateway `10.17.45.129`.
- USR1: `10.17.45.20`.
- WEB1: `10.17.45.130`.
- DB1: `10.17.45.131`.

Explicar que los usuarios y servidores están separados por VLAN y que el tráfico inter-VLAN pasa por FortiGate.

## 3. Rutas y NAT

En **Network → Routing**, mostrar la ruta por defecto:

`0.0.0.0/0 → 192.168.22.2 por port1`.

Explicar que la política de servidores hacia Internet utiliza NAT para las salidas DNS, HTTP y HTTPS.

## 4. Políticas de firewall

En **Policy & Objects → Firewall Policy**, mostrar:

1. `USERS_TO_WEB_HTTPS`: permite usuarios hacia WEB1 por HTTPS.
2. `USERS_TO_DB_BLOCK_MYSQL`: bloquea usuarios hacia DB1 por TCP/3306.
3. `WEB_TO_DB_MYSQL`: permite WEB1 hacia DB1 únicamente por TCP/3306.
4. `WEB_TO_DB_BLOCK_OTHER`: bloquea otros puertos entre WEB1 y DB1.
5. `SERVERS_TO_INTERNET`: permite DNS/HTTP/HTTPS con NAT.

Mencionar que todas las políticas relevantes tienen logging habilitado.

## 5. Perfiles de seguridad

Mostrar la política HTTPS y explicar:

- IPS: `IPS_SQLI_LAB`.
- File Filter: `BLOCK_EXE_DOWNLOADS`.
- SSL inspection: `certificate-inspection`.
- DoS policy: `DOS_LIMIT_USERS_WEB`, con protección TCP SYN.

Indicar honestamente que las pruebas SQL Injection no produjeron eventos IPS en esta versión/licencia; esa limitación está documentada en `evidencias/ips-sqli-resultado.txt`.

## 6. Pruebas funcionales

Ejecutar o mostrar las evidencias:

- USR1 → WEB1 HTTPS: HTTP 200, `Web Server is running`.
- USR1 → DB1:3306: bloqueado por timeout.
- WEB1 → DB1:3306: permitido; se consulta `practica.productos`.
- WEB1 → DB1:22: bloqueado.
- WEB1 → DB1:33060: bloqueado.
- Descarga de `lab.exe`: bloqueada por File Filter.
- SQL Injection: sin evento IPS, documentado como limitación.

## 7. Switch

Mostrar los comandos de verificación:

```text
show vlan brief
show interfaces trunk
show port-security
show ip dhcp snooping
show spanning-tree summary
```

Explicar que el switch tiene port-security, DHCP snooping, PortFast y BPDU Guard en los puertos de acceso.

## 8. Cierre

Mostrar el repositorio de GitHub, el README, el diagrama, los scripts y las evidencias. Indicar que el video demuestra la segmentación, las políticas, los controles de seguridad y las pruebas permitidas y bloqueadas.

## Comandos para ejecutar durante el video

Abrir PowerShell y ubicarse en la carpeta del proyecto:

```powershell
cd "C:\Users\Sacra\Documents\SEGURIDAD DE REDES\ISOS\PNETLab-listo"
$env:PNET_AUDIT_PASSWORD='pnet'
```

### Estado general

```powershell
node .audit-tools/read-pnet.cjs scripts/auditoria/estado-actual.sh
```

Mostrar interfaces, rutas, servicios HTTPS y MySQL.

### Prueba de usuarios hacia WEB1

```powershell
node .audit-tools/read-pnet.cjs scripts/auditoria/prueba-politicas-nuevo.sh
```

La prueba HTTPS normal debe mostrar `HTTP/1.1 200 OK` y `Web Server is running`. La prueba SQL Injection se presenta como limitación documentada si devuelve `404` y no genera evento IPS.

### Prueba WEB1 hacia DB1 por MySQL

```powershell
node .audit-tools/read-pnet.cjs scripts/auditoria/prueba-mysql-tcp.sh
```

Debe mostrar el usuario `webapp@10.17.45.130` y las filas de `practica.productos`.

### Bloqueo de usuarios hacia DB1

```powershell
node .audit-tools/read-pnet.cjs scripts/auditoria/prueba-usuario-db.sh
```

Debe terminar con `RESULTADO: BLOCKED`.

### Bloqueo de otros puertos WEB1 → DB1

```powershell
node .audit-tools/read-pnet.cjs scripts/auditoria/prueba-web-db-puertos.sh
```

Los puertos 22 y 33060 deben aparecer como `BLOCKED`.

### Prueba del filtro `.exe`

```powershell
node .audit-tools/read-pnet.cjs scripts/auditoria/preparar-y-probar-exe.sh
```

La descarga de `lab.exe` debe agotarse por timeout. Explicar que el File Filter interrumpió la transferencia.

### Verificación del switch

```powershell
node .audit-tools/read-pnet.cjs scripts/auditoria/switch.sh
```

Mostrar VLAN, trunk, port-security, DHCP snooping y spanning-tree.

No ejecutar comandos de configuración del FortiGate durante el video: la consigna exige que su configuración y demostración se realicen por GUI.
