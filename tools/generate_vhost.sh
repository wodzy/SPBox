#!/bin/bash

set -o errexit

#Default parameters
domain=$1
rootDir=$2
opt=$3
bk=$4
sitesAvailable='/etc/apache2/sites-available/'

if [[ $# -eq 0 ]]; then
    echo "$(tput setaf 1) Parameters required. Use like:$(tput setaf 7)
    gvhost [ServerName] [DocumentRoot] [reload] [save]"
    exit 0
fi

echo "<VirtualHost *:80>
	            AddDefaultCharset utf-8
	            ServerName "$domain"
	            ServerAlias www."$domain"
	            DocumentRoot "$rootDir"

	            <Directory "$rootDir" >
	             AllowOverride All
	             Order allow,deny
	             allow from all
	             #others guidelines here if needed..
                    </Directory>

	            ErrorLog /var/log/apache2/"$domain"-error_log
	            TransferLog /var/log/apache2/"$domain"-access_log
</VirtualHost>" > $sitesAvailable$domain.conf


if [ -e $sitesAvailable$domain.conf ]; then
    echo "$(tput setaf 2)Virtual Host Created ($domain.conf)"
else
    echo "$(tput setaf 1)Error : File not generated.."
fi

a2ensite $domain.conf

if [ $opt = "reload" ]; then
	/etc/init.d/apache2 reload
else
	echo "$(tput setaf 4) Apache not restarted"
fi

if [ $bk = "save" ]; then
  sudo cp /etc/apache2/sites-available/$domain.conf /var/shared/config/apache2/vhost/backup
else
  echo "$(tput setaf 1)Attention: you have not saved your vhost.
   When you destroy your vagrant, your vhost will be lost..."
fi
