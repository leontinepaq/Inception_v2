#!/bin/bash
DB_PWD=$(cat ${DB_PWD_FILE})
service mariadb start
# service mariadb status
sleep 5
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PWD}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO \`${DB_USER}\`@'%';"
service mariadb stop
exec mysqld_safe --bind-address=0.0.0.0