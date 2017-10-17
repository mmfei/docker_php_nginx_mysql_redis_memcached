#!/bin/bash

# start ssh service
# /usr/sbin/sshd &
/usr/local/nginx/sbin/nginx;

# start nginx service
docker-php-entrypoint php-fpm;