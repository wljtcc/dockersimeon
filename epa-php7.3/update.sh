#!/bin/bash

echo "Update"
export DEBIAN_FRONTEND="noninteractive"
apt -y update
apt -y install wget
echo "Upgrade"
apt -y upgrade

echo "Remove Cache APT"
# Removendo cache
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*

# Set permission run.sh
chmod 0777 /etc/init.d/run.sh

touch /var/spool/cron/crontabs/root
echo "* * * * * php \$EPA_PATH/api/artisan schedule:run &> /dev/null" >> /var/spool/cron/crontabs/root
chown root:crontab /var/spool/cron/crontabs/root
chmod 0600 /var/spool/cron/crontabs/root
