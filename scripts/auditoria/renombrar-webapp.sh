docker exec docker4 mysql -u root -e "RENAME USER 'webapp'@'192.168.20.10' TO 'webapp'@'10.17.45.130'; FLUSH PRIVILEGES; SHOW GRANTS FOR 'webapp'@'10.17.45.130';"
