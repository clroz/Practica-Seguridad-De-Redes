# Laboratorio: FortiGate, segmentación y protección de servidores

## Propósito

Construir una red pequeña en PNETLab donde FortiGate controle el tráfico entre usuarios y servidores, publique el servidor web por HTTPS y aplique inspección, IPS, filtrado de archivos y protección contra ataques de denegación de servicio. La configuración del FortiGate y las demostraciones se realizan desde su GUI.

## Topología propuesta

```text
                         Cloud0 / Internet
                                |
                         port1 FortiGate
                                |
               port2 (trunk VLAN 10, VLAN 20)
                                |
                             SW1
                 _____________|_____________
                |             |             |
          VLAN 10         VLAN 20        VLAN 20
        Usuarios/DHCP     WEB-Server      DB-Server
                          HTTPS :443      MySQL :3306
```

El puerto de administración de FortiGate se usa solo para acceder a la GUI durante el montaje. El tráfico de usuarios y servidores pasa por las subinterfaces VLAN del puerto LAN.

## Direccionamiento

| Segmento | VLAN | Red | Puerta de enlace | Direcciones reservadas |
|---|---:|---|---|---|
| Usuarios | 10 | `192.168.10.0/25` | `192.168.10.1` | DHCP desde `.20` hasta `.120` |
| Servidores | 20 | `192.168.20.0/28` | `192.168.20.1` | WEB `.10`, DB `.11` |

FortiGate debe tener `192.168.10.1/25` en la subinterfaz VLAN 10 y `192.168.20.1/28` en la subinterfaz VLAN 20. Los servidores deben usar `192.168.20.1` como gateway. El DNS y la hora deben quedar configurados para que los perfiles de seguridad y los registros funcionen correctamente.

## Orden de implementación

1. Crear en PNETLab un FortiGate, un switch vIOS L2, un equipo de usuario y los dos servidores. Conectar `port1` del FortiGate a Cloud0 y `port2` al puerto troncal del switch.
2. En el switch crear VLAN 10 y VLAN 20. Configurar el puerto hacia FortiGate como trunk y los puertos de usuarios como access VLAN 10; los puertos de servidores como access VLAN 20.
3. En FortiGate crear las interfaces VLAN 10 y 20 sobre `port2`, asignar el direccionamiento anterior y activar DHCP solo en VLAN 10.
4. Configurar ruta por defecto por el gateway que entregue Cloud0. Si Cloud0 no entrega DHCP, asignar la dirección WAN y el gateway indicados por el entorno PNETLab.
5. Configurar WEB-Server para HTTPS y DB-Server para MySQL. Verificar primero conectividad básica desde cada segmento.
6. Crear los objetos de dirección `USERS_NET`, `WEB_SERVER` y `DB_SERVER`, y después las políticas en este orden:
   - Usuarios → WEB-Server, TCP/443, acción aceptar, NAT según el diseño.
   - Usuarios → DB-Server, TCP/3306, acción denegar y registrar.
   - WEB-Server → DB-Server, TCP/3306, acción aceptar y registrar.
   - WEB-Server → DB-Server, cualquier servicio, acción denegar y registrar.
7. Activar inspección SSL profunda en una política de prueba y distribuir el certificado CA de FortiGate al usuario de laboratorio. Aplicar el perfil IPS con firmas de inyección SQL en modo bloqueo y cuarentena del atacante.
8. Aplicar filtro de archivos para bloquear descargas `.exe` y un perfil de control de aplicaciones en las políticas de salida web.
9. Crear una política DoS para el servicio HTTPS publicado, con umbrales conservadores de SYN flood, TCP port scan y HTTP request flood. Ajustar los umbrales después de observar el tráfico normal.
10. Probar y guardar los running-configs del switch, de los servidores y las capturas de pantalla de la GUI de FortiGate.

## Criterios de aceptación

- Un usuario obtiene una dirección de VLAN 10 por DHCP.
- Un usuario puede abrir `https://WEB_SERVER` y la sesión queda registrada.
- Un usuario no puede conectar a `DB_SERVER:3306`.
- WEB-Server puede conectar a DB-Server únicamente por `3306`; otros puertos son rechazados.
- Una descarga de prueba `.exe` queda bloqueada y aparece en los logs.
- Un payload SQLi dirigido al web server es bloqueado por IPS, queda registrado y el origen aparece en la lista de cuarentena.
- Los eventos de rate limiting aparecen en los logs cuando se supera el umbral configurado.
- La configuración se guarda después de cada bloque de cambios.

## Nota sobre la GUI

Los nombres exactos de algunos menús dependen de la vista de FortiOS 7.0.9 y de si se habilita `System > Feature Visibility`. En particular, la inspección profunda requiere instalar el certificado CA en el cliente y puede producir advertencias HTTPS hasta que el certificado sea confiable.
