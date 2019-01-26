#!/bin/bash
set -o errexit
# Default password of MariaDB
MARIADB_PASSWORD='1234'
# Stop STDIN
export DEBIAN_FRONTEND=noninteractive

# Fix locale
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

echo "-------------------------------------------------------------------------"
echo Installing the essential tools and packages...
echo "-------------------------------------------------------------------------"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get install -y make build-essential libssl-dev libncurses5-dev debconf-utils software-properties-common dirmngr
sudo apt-get install -y wget curl emacs git zip unzip
sudo cp /var/shared/tools/generate_vhost.sh /usr/bin/gvhost
sudo apt-get install -y htop

echo "-------------------------------------------------------------------------"
echo Installing Apache2
echo "-------------------------------------------------------------------------"
sudo apt-get install -y apache2

echo "-------------------------------------------------------------------------"
echo Preparing and installing MariaDB
echo "-------------------------------------------------------------------------"

# Set password and install MariaDB
echo "Preparing MariaDB..."
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MARIADB_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MARIADB_PASSWORD"
sudo apt-get install -y mariadb-server

echo "-------------------------------------------------------------------------"
echo Installing Redis and configuration
echo "-------------------------------------------------------------------------"
sudo apt-get install -y redis-server
sudo cp /var/shared/config/redis/redis.conf /etc/redis/redis.config

echo "-------------------------------------------------------------------------"
echo Installing PHP7
echo "-------------------------------------------------------------------------"
sudo apt-get -y install apt-transport-https lsb-release ca-certificates
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" >> /etc/apt/sources.list.d/php.list
sudo apt-get -y update
sudo apt-get -y install php7.2 php7.2-opcache libapache2-mod-php7.2 php7.2-mysql php7.2-curl php7.2-json php7.2-gd  php7.2-intl php7.2-mbstring php7.2-xml php7.2-zip php7.2-fpm php7.2-readline

echo "-------------------------------------------------------------------------"
echo Apache2 and PHP7 configuration
echo "-------------------------------------------------------------------------"
sudo cp /var/shared/config/apache2/apache2.conf /etc/apache2/apache2.conf
sudo a2enmod rewrite
sudo cp /var/shared/config/php/7.2/apache2/php.ini /etc/php/7.2/apache2/php.ini
sudo cp /var/shared/config/php/7.2/cli/php.ini /etc/php/7.2/cli/php.ini
sudo cp /var/shared/config/php/7.2/fpm/php.ini /etc/php/7.2/fpm/php.ini
sudo cp /var/shared/config/php/7.2/fpm/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php7.2-fpm
sudo a2dismod php7.2
sudo cp /var/shared/config/apache2/vhost/default/localhost.local.conf /etc/apache2/sites-available
sudo a2ensite localhost.local.conf
sudo service apache2 reload

echo "-------------------------------------------------------------------------"
echo Installing composer
echo "-------------------------------------------------------------------------"
sudo curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo rm composer-setup.php

echo "-------------------------------------------------------------------------"
echo Installing NodeJS
echo "-------------------------------------------------------------------------"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "-------------------------------------------------------------------------"
echo Installing ngrok
echo "-------------------------------------------------------------------------"
sudo wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
sudo unzip ngrok-stable-linux-amd64.zip
sudo rm ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/bin/ngrok

echo "-------------------------------------------------------------------------"
echo Installing maildev
echo "-------------------------------------------------------------------------"
sudo npm install -g maildev
