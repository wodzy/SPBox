#Create root user with all privilege
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.%' IDENTIFIED BY '1234' WITH GRANT OPTION;
