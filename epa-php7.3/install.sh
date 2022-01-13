#!/bin/bash

echo "Update"
export DEBIAN_FRONTEND="noninteractive"
apt -y update
apt -y install wget
echo "Upgrade"
apt -y upgrade

echo "Install Repository"
apt -y install apt-transport-https ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list

echo "Update"
export DEBIAN_FRONTEND="noninteractive"
apt -y update
echo "Upgrade"
apt -y upgrade

echo "Install Deps"
apt -y install apt-utils
apt -y install \
        curl \
        locales \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libicu-dev \
        libldap2-dev \
        libfontconfig1 \
        libxext6 \
        libxrender1 \
        cron

apt -y install apache2 \
               apache2-bin \
               apache2-data \
               apache2-utils \
               libapache2-mod-php7.3

apt -y install php7.3 \
               php7.3-common \
               php-apcu \
               php7.3-dev \
               php7.3-cli \
               php7.3-curl \
               php7.3-gd \
               php7.3-intl \
               php7.3-imap \
               php7.3-ldap \
               php7.3-mysql \
               php7.3-mbstring \
               php7.3-zip \
               php-xdebug \
               php7.3-xml \
               php7.3-gmp

printf "\n" | pecl install mcrypt

echo extension=mcrypt.so >> /etc/php/7.3/apache2/conf.d/20-mcrypt.ini

echo "Enable Modules PHP"
a2enmod rewrite
a2enmod headers
a2enmod deflate
a2enmod expires

echo "Enable LOCALES"
locale-gen pt_BR && locale-gen en_US
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
sed -i -e "s/export CHARSET=UTF-8//g" /etc/profile
echo "export CHARSET=\"pt_BR UTF-8\npt_BR.UTF-8 UTF-8\nen_US UTF-8\nen_US.UTF-8 UTF-8\"" >> /etc/profile
echo "export EPA_PATH" >> /etc/profile

echo "Criando o redirecionamento para o EPA"
mv /var/www/html/index.html /var/www/html/apache2.html
{ \
    echo '<?php'; \
    echo 'header("Location: /epa/");'; \
} | tee "/var/www/html/index.php"

echo "LIB IONCube"
# Instalando a biblioteca ionCube
cd /opt
curl -# -O https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -zxvf ioncube_loaders_lin_x86-64.tar.gz
mv /opt/ioncube/ioncube_loader_lin_7.3.so /usr/lib/php/20180731/
echo "zend_extension = /usr/lib/php/20180731/ioncube_loader_lin_7.3.so" > /etc/php/7.3/apache2/conf.d/00-ioncube.ini
rm -rf /opt/ioncube*

echo "Cria PHPInfo"
echo "<?php" > /var/www/html/phpinfo.php
echo "phpinfo();" >> /var/www/html/phpinfo.php
echo "phpinfo(INFO_MODULES);"  >> /var/www/html/phpinfo.php
echo "?>" >> /var/www/html/phpinfo.php

mv /etc/php/7.3/apache2/php.ini /etc/php/7.3/apache2/php.ini.default
mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.default

echo "Remove Cache APT"
# Removendo cache
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*

# Set permission run.sh
chmod 0777 /etc/init.d/run.sh

rm -rf /var/spool/cron/crontabs/root
echo "* * * * * php \$EPA_PATH/api/artisan schedule:run &> /dev/null" > /var/spool/cron/crontabs/root
chown root:crontab /var/spool/cron/crontabs/root
chmod 0600 /var/spool/cron/crontabs/root
