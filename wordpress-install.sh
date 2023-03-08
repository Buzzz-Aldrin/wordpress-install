#!/bin/bash

#Ставим Apache
sudo apt update
sudo apt -y install apache2 apache2-utils
sudo systemctl enable apache2
sudo systemctl start apache2

#Задаем переменные для MariaDB
read -p 'Database name: ' db_name
read -p 'Database username: ' db_user
read -p 'Database password: ' db_userpass

#Ставим MariaDB, создаем пользователя, пароль и БД
sudo apt -y install mariadb-server mariadb-client mariadb-common
sudo mysql -uroot <<MYSQL_SCRIPT
CREATE DATABASE $db_name;
CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_userpass';
GRANT ALL PRIVILEGES ON wp_database.* TO '$db_user'@'localhost';
GRANT ALL PRIVILEGES ON wp_database.* TO '$db_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT

#Ставим PHP
sudo apt -y install php7.4 php7.4-mysql libapache2-mod-php7.4 php7.4-cli php7.4-cgi php7.4-gd

#Активируем модули Apache, рестартуем сервер
sudo a2enmod rewrite
sudo systemctl restart apache2

#Качаем, распаковывем, переносим содержимое архива c Wordpress
cd ~
sudo wget -c https://wordpress.org/latest.zip
sudo apt -y install zip
sudo unzip latest.zip
sudo mv ./wordpress/* /var/www/html/
sudo rm -rf wordpress latest.zip

#Меняем владельца папки с wordpress, изменяем права
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

echo "Success! LAMP has been successfully installed. Please open your browser, type in IP adding /wp-admin/ to finish installing wordpress."
echo "Your IP"
hostname -I
echo "Data Base name is $db_name"
echo "Data Base user is $db_user"
echo "Password: $db_userpass"
