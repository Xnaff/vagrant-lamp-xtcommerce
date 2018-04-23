#!/usr/bin/env bash

PASSWORD='vagrant'

echo -e "\n--- Update ---\n"
sudo apt-get update

echo -e "\n--- Install Apache2 ---\n"
sudo apt-get install -y apache2

echo -e "\n--- Install PHP 7.0 ---\n"
sudo apt-get install -y software-properties-common
sudo apt-get install -y language-pack-en-base
sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt install -y php7.0 libapache2-mod-php7.0 php7.0-common php7.0-mbstring php7.0-xmlrpc php7.0-soap php7.0-gd php7.0-xml php7.0-intl php7.0-mysql php7.0-cli php7.0-mcrypt php7.0-zip php7.0-curl

echo -e "\n--- Install MySQL ---\n"
sudo add-apt-repository -y ppa:ondrej/mysql-5.6
sudo apt-get update
debconf-set-selections <<< "mysql-server-5.6 mysql-server/root_password password $PASSWORD"
debconf-set-selections <<< "mysql-server-5.6 mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server-5.6

echo -e "\n--- Restart Apache ---\n"
sudo service apache2 restart

echo -e "\n--- Install IonCube ---\n"
echo -n "[In progress] Donwload the tar.gz archive ..."
wget -q "http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz"
echo -e "\r\e[0;32m[OK]\e[0m Donwload the tar.gz archive"
tar xvfz ioncube_loaders_lin_x86-64.tar.gz
sudo cp ioncube/ioncube_loader_lin_7.0.so /usr/lib/php/20151012/
sudo echo "zend_extension=/usr/lib/php/20151012/ioncube_loader_lin_7.0.so" > /etc/php/7.0/apache2/conf.d/00-ioncube.ini

echo -e "\n--- Restart Apache ---\n"
sudo systemctl restart apache2.service
sudo rm ioncube_loaders_lin_x86-64.tar.gz
sudo rm -rf ioncube_loaders_lin_x86-64

echo -e "\n--- Create Virtual Host ---\n"
VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerName xtcommerce.local
    ServerAlias www.xtcommerce.local
    DocumentRoot /var/www/html/xtcommerce
    <Directory /var/www/html/xtcommerce>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

echo -e "\n--- Activate mod_rewrite ---\n"
sudo a2enmod rewrite

echo -e "\n--- Restart Apache ---\n"
sudo service apache2 restart

mysql -u root -p $PASSWORD -e "create database xtcommerce";

echo -e "\n--- Stop MySQL ---\n"
sudo /etc/init.d/mysql stop