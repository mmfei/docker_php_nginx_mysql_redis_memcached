FROM php:5.6-fpm
MAINTAINER k12-PHP "wlfkongl@163.com"
ENV NGINX_VERSION 1.13.5
ENV LUA_MODULE_VERSION 0.10.10

ADD sources.list    /etc/apt/sources.list
RUN pecl channel-update pecl.php.net
# 安装modules
RUN apt-get update && apt-get install -y \
        #libxml2-dev \
        libfreetype6-dev \
        libmemcached-dev \
        libmcrypt-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        unzip \
        graphviz \
        vim \
        curl \
        tree \
        wget
RUN docker-php-ext-install -j$(nproc) iconv mcrypt \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install -j$(nproc) gd \
        && docker-php-ext-install mysqli \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache \
        && docker-php-ext-install zip
RUN pecl install channel://pecl.php.net/xhprof-0.9.4 \
        && docker-php-ext-enable xhprof

RUN pecl install channel://pecl.php.net/xdebug-2.5.5 \
        && docker-php-ext-enable xdebug
 
RUN pecl install redis \
        && docker-php-ext-enable redis 
RUN pecl install memcache \
        && docker-php-ext-enable memcache
RUN pecl install channel://pecl.php.net/memcached-2.2.0 \
        && docker-php-ext-enable memcached
RUN docker-php-ext-install mysql
ADD php.ini    /usr/local/etc/php/php.ini
ADD php-fpm.conf    /usr/local/etc/php-fpm.conf

# RUN echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_host=192.168.13.128" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=19001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.auto_trace=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_log=/var/log/xdebug_remote.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN wget https://getcomposer.org/installer -O composer-setup.php; php composer-setup.php; mv composer.phar /usr/local/bin/composer        

# 安装 Xdebug
# RUN curl -fsSL 'https://xdebug.org/files/xdebug-2.4.0.tgz' -o xdebug.tar.gz \
#     && mkdir -p xdebug \
#     && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
#     && rm xdebug.tar.gz \
#     && ( \
#     cd xdebug \
#     && phpize \
#     && ./configure --enable-xdebug \
#     && make -j$(nproc) \
#     && make install \
#     ) \
#     && rm -r xdebug \
#     && docker-php-ext-enable xdebug
#配置 debugger
# RUN echo "xdebug.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_host=192.168.13.224" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


WORKDIR /data1

RUN usermod -u 1000 www-data
RUN  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apt-get -y install libpcre3 libpcre3-dev zlib1g-dev libssl-dev build-essential wget
RUN wget http://www.openssl.org/source/openssl-1.0.2a.tar.gz;tar -zxvf openssl-1.0.2a.tar.gz -C /usr/local/src/;cd /usr/local/src/openssl-1.0.2a/;./config;make && make install;
RUN wget http://nginx.org/download/nginx-1.8.0.tar.gz;tar zxvf nginx-1.8.0.tar.gz -C .;mkdir -p /usr/local/nginx;cd nginx-1.8.0 && ./configure --prefix=/usr/local/nginx --with-openssl=/usr/include/openssl && make && make install
RUN rm -vf /usr/local/nginx/conf/nginx.conf

ADD  nginx.conf      /usr/local/nginx/conf/nginx.conf
ADD  locations.conf      /usr/local/nginx/conf/locations.conf
# ADD  sites-enabled/*    /usr/local/nginx/conf/conf.d/
ADD  nginx    /etc/init.d/
RUN  chmod a+x /etc/init.d/nginx;
RUN  ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx
ADD  run.sh    /
RUN  chmod a+x /run.sh;
ENTRYPOINT ["/run.sh"]

# RUN  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# CMD ["/run.sh"]
# CMD ["/etc/docker-entrypoint.sh", "/usr/local/nginx/sbin/nginx"]
# ENTRYPOINT ["docker-entrypoint.sh /usr/local/nginx/sbin/nginx"]

# nginx:80 php-fpm:9000
EXPOSE 80 9000
VOLUME ["/data1"]
