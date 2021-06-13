#!/usr/bin/env bash
set -e

service nginx restart
service php7.1-fpm restart
service postgresql restart
systemctl restart freeswitch

exec /bin/systemctl
