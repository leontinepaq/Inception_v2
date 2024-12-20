#!/bin/bash
#https://make.wordpress.org/cli/handbook/how-to/how-to-install/
DB_PWD=$(cat $DB_PWD_FILE)
WP_USER_PWD=$(cat $WP_USER_PWD_FILE)
WP_ADMIN_PWD=$(cat $WP_ADMIN_PWD_FILE)

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

chmod -R 755 /var/www/wordpress/
cd /var/www/wordpress

#wait for the db to be created
echo "-------------------------------------"
until mariadb -h mariadb -u "${DB_USER}" -p"${DB_PWD}" -e "USE ${DB_NAME}"; do
  sleep 3
  echo "Waiting for the database to be created"
done
echo "Database is ready"
echo "-------------------------------------"

#config wordpress if not already done
if [ ! -f wp-config.php ]
then 
	wp core download --allow-root
	wp config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PWD} --dbhost=mariadb:3306 --allow-root
	wp core install --url=${DOMAIN_NAME} --title="INCEPTION" --admin_user=${WP_ADMIN_NAME} --admin_password=${WP_ADMIN_PWD} --admin_email=${WP_ADMIN_MAIL} --allow-root
	wp user create ${WP_USER_NAME} ${WP_USER_MAIL} --role=${WP_USER_ROLE} --user_pass=${WP_USER_PWD} --allow-root

	#redis cache
	chown www-data:www-data -R /var/www
	wp config set WP_CACHE true --raw --allow-root
	wp config set WP_REDIS_HOST 'redis' --allow-root
	wp config set WP_REDIS_PORT '6379' --allow-root
	wp plugin install redis-cache --activate --allow-root
	wp redis enable --allow-root
fi

mkdir -p /run/php
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf
/usr/sbin/php-fpm7.4 -F