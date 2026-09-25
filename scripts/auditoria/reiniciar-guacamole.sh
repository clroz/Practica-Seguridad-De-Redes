#!/bin/bash
set -u
test "$(hostname)" = pnetlab
systemctl restart guacd 2>/dev/null || systemctl restart guacamole 2>/dev/null || true
systemctl restart apache2
systemctl is-active guacd 2>/dev/null || true
systemctl is-active apache2
