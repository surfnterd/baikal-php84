#!/bin/sh
set -e
mkdir -p /var/www/baikal/Specific/db
chown -R baikal:baikal /var/www/baikal/Specific /var/www/baikal/config
php-fpm -D
exec nginx -g 'daemon off;'
