docker exec docker4 sh -c 'mysql --protocol=TCP --host=10.17.45.131 --port=3306 --connect-timeout=5 -u root -e "SELECT VERSION();"'
