FROM nginx:1.10.1

MAINTAINER k12-NGINX "wlfkongl@163.com"


ADD  nginx.conf      /etc/nginx/nginx.conf
ADD  locations.conf      /etc/nginx/locations.conf
ADD  sites-enabled/*    /etc/nginx/conf.d/
# RUN  mkdir /data1/htdocs && mkdir /data1/log && mkdir /data1/log/nginx
# RUN  chown -R www-data.www-data /data1/htdocs /data1/log
RUN  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
EXPOSE 80
VOLUME ["/data1"]

