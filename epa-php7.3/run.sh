#!/bin/sh

env >> /etc/environment

# Start CRON
/usr/sbin/cron -f &

echo "Starting apache daemon..."
# run apache daemon
php $EPA_PATH/api/artisan queue:work &> /dev/null &
apache2ctl -D FOREGROUND