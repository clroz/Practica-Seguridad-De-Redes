#!/bin/bash
set -eu
docker exec docker4 mysql -u root <<'SQL'
SET @old_exists = (SELECT COUNT(*) FROM mysql.user WHERE User='webapp' AND Host='192.168.20.10');
SET @new_exists = (SELECT COUNT(*) FROM mysql.user WHERE User='webapp' AND Host='10.17.45.130');
SET @sql = IF(@old_exists > 0 AND @new_exists = 0,
  "RENAME USER 'webapp'@'192.168.20.10' TO 'webapp'@'10.17.45.130'",
  'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'webapp'@'10.17.45.130';
SQL
docker exec docker3 sh -c "sed -i 's/^host=.*/host=10.17.45.131/' /root/.my-practica.cnf"
