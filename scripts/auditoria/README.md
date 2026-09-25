# Scripts de la revisión

Estos scripts se usaron para revisar y posteriormente trasladar DB1 el 25 de septiembre de 2026. **migrar-db1.sh sí modifica el switch, direccionamiento/rutas y una regla INPUT dentro de DB1**, y guarda el switch. Los demás scripts son de consulta y pruebas. Ninguno modifica FortiGate por CLI. Las pruebas TCP y HTTPS generan tráfico normal y pueden producir registros de acceso.

`read-pnet.cjs` ejecuta el archivo seleccionado por SSH. Requiere Node.js y la dependencia `ssh2`: instalar con `npm.cmd install --prefix scripts/auditoria --ignore-scripts`. Proporcionar `PNET_AUDIT_PASSWORD` mediante el entorno de la sesión, nunca escribirla en los archivos versionados. `PNET_AUDIT_HOST` permite cambiar la dirección del host; por defecto usa 192.168.22.132. Este ayudante local no implementa pinning de clave del host; su uso en esta revisión se limitó al host de laboratorio identificado por el usuario.

Ejemplo, después de establecer las variables de entorno de forma privada:

```powershell
node scripts/auditoria/read-pnet.cjs scripts/auditoria/inventory.sh
```

| Archivo | Consulta |
|---|---|
| inventory.sh | Host, contenedores activos, laboratorio y direcciones |
| details.sh | XML de nodos/enlaces, contenedores, servicios y MySQL sin hashes de usuarios |
| consoles.sh | Disponibilidad de consolas, Apache y bridges |
| switch.sh | Estado de VLAN, trunk y seguridad del switch; primer intento de lectura de configuración |
| verify.sh | Lectura completa con paginación corregida, intento de lectura de FortiGate y petición HTTPS |
| connectivity.sh | Conexiones TCP individuales con dirección origen explícita y comprobación HTTPS local |
| fortigate.sh | Consulta de interfaces, rutas, DHCP, políticas, DoS y VIP si la consola está autenticada |
| pre-migracion.sh | Estado de contenedores, red y respaldo textual del switch antes del traslado |
| arranque.sh | Inspección de entrypoints y herramientas disponibles |
| migrar-db1.sh | Cambio autorizado a VLAN30, guardado del switch, rutas y bloqueo de entrada Docker en DB1 |
| verificar-vlan30.sh | Comprobación de conexiones, HTTPS y MySQL después del traslado |

Se conservan también los primeros scripts de diagnóstico para mantener trazabilidad. `switch.sh` obtuvo configuración truncada por la paginación; `verify.sh` corrigió ese problema usando retorno de carro sin salto de línea adicional. No interpretar una salida truncada como configuración completa. Algunas consultas de herramientas no instaladas devuelven error; se documentaron los resultados útiles en `ESTADO-PRACTICA.md`.

Las consolas telnet se acceden por localhost dentro del canal SSH y pueden compartir sesión con la interfaz de PNETLab. Evitar escribir manualmente al mismo tiempo. Los comandos de FortiGate solo se envían si se detecta una sesión autenticada; no se introducen contraseñas ni se cambia la configuración. La demostración exigida por el profesor debe realizarse por GUI.

No publicar salidas sin revisarlas: las configuraciones podrían contener datos sensibles aunque estos scripts filtren algunas líneas de credenciales. Las dependencias y herramientas temporales están excluidas por `.gitignore`.
