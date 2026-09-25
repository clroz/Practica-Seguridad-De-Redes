docker exec docker3 mysql --defaults-extra-file=/root/.my-practica.cnf --connect-timeout=30 -e 'SELECT USER(), CURRENT_USER(), DATABASE(); SELECT * FROM productos;'
