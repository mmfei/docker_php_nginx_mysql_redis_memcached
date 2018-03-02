FROM centos:7
MAINTAINER Skiychan <dev@skiy.net>

ENV NGINX_VERSION 1.11.6
ENV PHP_VERSION 7.1.0

RUN set -x && \
    yum install -y gcc \
    gcc-c++ \
    autoconf \
    automake \
    libtool \
    make \
    cmake && \

#Install PHP library
## libmcrypt-devel DIY
    rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && \
    yum install -y zlib \
    zlib-devel \
    openssl \
    openssl-devel \
    pcre-devel \
    libxml2 \
    libxml2-devel \
    libcurl \
    libcurl-devel \
    libpng-devel \
    libjpeg-devel \
    freetype-devel \
    libmcrypt-devel \
    openssh-server \
    python-setuptools && \

#Add user
    mkdir -p /data/{www,phpext} && \
    useradd -r -s /sbin/nologin -d /data/www -m -k no www && \

#Download nginx & php
    mkdir -p /home/nginx-php && cd $_ && \
    curl -Lk http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
    curl -Lk http://php.net/distributions/php-$PHP_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \

#Make install nginx
    cd /home/nginx-php/nginx-$NGINX_VERSION && \
    ./configure --prefix=/usr/local/nginx \
    --user=www --group=www \
    --error-log-path=/var/log/nginx_error.log \
    --http-log-path=/var/log/nginx_access.log \
    --pid-path=/var/run/nginx.pid \
    --with-pcre \
    --with-http_ssl_module \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --with-http_gzip_static_module && \
    make && make install && \

#Make install php
    cd /home/nginx-php/php-$PHP_VERSION && \
    ./configure --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --with-config-file-scan-dir=/usr/local/php/etc/php.d \
    --with-fpm-user=www \
    --with-fpm-group=www \
    --with-mcrypt=/usr/include \
    --with-mysqli \
    --with-pdo-mysql \
    --with-openssl \
    --with-gd \
    --with-iconv \
    --with-zlib \
    --with-gettext \
    --with-curl \
    --with-png-dir \
    --with-jpeg-dir \
    --with-freetype-dir \
    --with-xmlrpc \
    --with-mhash \
    --enable-fpm \
    --enable-xml \
    --enable-shmop \
    --enable-sysvsem \
    --enable-inline-optimization \
    --enable-mbregex \
    --enable-mbstring \
    --enable-ftp \
    --enable-gd-native-ttf \
    --enable-mysqlnd \
    --enable-pcntl \
    --enable-sockets \
    --enable-zip \
    --enable-soap \
    --enable-session \
    --enable-opcache \
    --enable-bcmath \
    --enable-exif \
    --enable-fileinfo \
    --disable-rpath \
    --enable-ipv6 \
    --disable-debug \
    --without-pear && \
    make && make install && \


#Install php-fpm
    cd /home/nginx-php/php-$PHP_VERSION && \
    cp php.ini-production /usr/local/php/etc/php.ini && \
    cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
    cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf && \

#Install supervisor
    easy_install supervisor && \
    mkdir -p /var/{log/supervisor,run/{sshd,supervisord}} && \

#Clean OS
    yum remove -y gcc \
    gcc-c++ \
    autoconf \
    automake \
    libtool \
    make \
    cmake && \
    yum clean all && \
    rm -rf /tmp/* /var/cache/{yum,ldconfig} /etc/my.cnf{,.d} && \
    mkdir -p --mode=0755 /var/cache/{yum,ldconfig} && \
    find /var/log -type f -delete && \
    rm -rf /home/nginx-php && \

#Change Mod from webdir
    chown -R www:www /data/www

#Add supervisord conf
ADD supervisord.conf /etc/

#Create web folder
VOLUME ["/data/www", "/usr/local/nginx/conf/ssl", "/usr/local/nginx/conf", "/usr/local/php/etc/php.d", "/data/phpext"]

# ADD index.php /data/www/

ADD extini/ /usr/local/php/etc/php.d/
ADD extfile/ /data/phpext/

#Update nginx config
ADD nginx.conf /usr/local/nginx/conf/

#Start
ADD start.sh /
RUN chmod +x /start.sh

#Set port
EXPOSE 80 443

#Start it
ENTRYPOINT ["/start.sh"]

#Start web server
#CMD ["/bin/bash", "/start.sh"]


# FROM php:7.2.2-fpm
# MAINTAINER mmfei-PHP "wlfkongl@163.com"

# ADD sources.list    /etc/apt/sources.list
# RUN pecl channel-update pecl.php.net
# # 安装modules
# RUN apt-get update


# RUN apt-get install -y \
#         unzip \
#         graphviz \
#         vim \
#         curl \
#         tree \
#         wget
# RUN apt-get install -y \
#         imagemagick

# # RUN apt-get install -y apt-utils apt

# RUN apt-get install -y zlib1g=1:1.2.8.dfsg-2+b1 --allow-downgrades

# RUN apt-get install -y \
#         zlib1g-dev \
#         libfreetype6-dev \
#         libz-dev \
#         libjpeg62-turbo-dev

# RUN apt-get install -y \
#         libmcrypt-dev 

# RUN apt-get install -y \
#         libpng12-dev \
#         libicu-dev \
#         libsqlite-dev \
#         libsqlite3-dev \
#         libmagickwand-dev \
#         libmagickcore-dev

#         # apt-get install -y \
#         # imagemagick \
#         # libfreetype6-dev \
#         # libjpeg62-turbo-dev \
#         # libmcrypt-dev \
#         # libpng12-dev \
#         # libicu-dev \
#         # libsqlite-dev \
#         # libsqlite3-dev \
#         # libmagickwand-dev \
#         # libmagickcore-dev
# # 
# RUN pecl install imagick

# # Install php extensions
# RUN docker-php-ext-install intl iconv mcrypt pdo pdo_mysql mysqli pdo_sqlite tokenizer\
#     && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#     && docker-php-ext-install gd \
#     && docker-php-ext-install opcache \
#     && docker-php-ext-install zip \
#     && docker-php-ext-install mbstring \
#     && docker-php-ext-install exif \
#     && docker-php-ext-enable imagick \
#     && docker-php-ext-install bcmath

# # soap
# RUN buildRequirements="libxml2-dev" \
#         && apt-get update && apt-get install -y ${buildRequirements} \
#         && docker-php-ext-install soap \
#         && apt-get purge -y ${buildRequirements} \
#         && rm -rf /var/lib/apt/lists/*


# # RUN docker-php-ext-install -j$(nproc) iconv mcrypt \
# #         && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
# #         && docker-php-ext-install -j$(nproc) gd \
# #         && docker-php-ext-install mysqli \
# #         && docker-php-ext-install pdo_mysql \
# #         && docker-php-ext-install opcache \
# #         && docker-php-ext-install zip
# RUN pecl install xhprof \
#         && docker-php-ext-enable xhprof

# RUN pecl install xdebug \
#         && docker-php-ext-enable xdebug
 
# RUN pecl install redis \
#         && docker-php-ext-enable redis 
# RUN pecl install memcache \
#         && docker-php-ext-enable memcache
# RUN pecl install memcached \
#         && docker-php-ext-enable memcached
# RUN docker-php-ext-install mysql
# ADD php.ini    /usr/local/etc/php/php.ini
# ADD php-fpm.conf    /usr/local/etc/php-fpm.conf

# # RUN echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_host=192.168.13.128" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_port=19001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# # RUN echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# # RUN echo "xdebug.auto_trace=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_log=/var/log/xdebug_remote.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN wget https://getcomposer.org/installer -O composer-setup.php; php composer-setup.php; mv composer.phar /usr/local/bin/composer        

# # 安装 Xdebug
# # RUN curl -fsSL 'https://xdebug.org/files/xdebug-2.4.0.tgz' -o xdebug.tar.gz \
# #     && mkdir -p xdebug \
# #     && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
# #     && rm xdebug.tar.gz \
# #     && ( \
# #     cd xdebug \
# #     && phpize \
# #     && ./configure --enable-xdebug \
# #     && make -j$(nproc) \
# #     && make install \
# #     ) \
# #     && rm -r xdebug \
# #     && docker-php-ext-enable xdebug
# #配置 debugger
# # RUN echo "xdebug.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# # RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# # RUN echo "xdebug.remote_host=192.168.13.224" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


# WORKDIR /data1

# RUN usermod -u 1000 www-data
# RUN  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# RUN apt-get -y install libpcre3 libpcre3-dev zlib1g-dev libssl-dev build-essential wget
# RUN wget http://www.openssl.org/source/openssl-1.0.2a.tar.gz;tar -zxvf openssl-1.0.2a.tar.gz -C /usr/local/src/;cd /usr/local/src/openssl-1.0.2a/;./config;make && make install;
# RUN wget http://nginx.org/download/nginx-1.8.0.tar.gz;tar zxvf nginx-1.8.0.tar.gz -C .;mkdir -p /usr/local/nginx;cd nginx-1.8.0 && ./configure --prefix=/usr/local/nginx --with-openssl=/usr/include/openssl && make && make install
# RUN rm -vf /usr/local/nginx/conf/nginx.conf

# ADD  nginx.conf      /usr/local/nginx/conf/nginx.conf
# ADD  locations.conf      /usr/local/nginx/conf/locations.conf
# # ADD  sites-enabled/*    /usr/local/nginx/conf/conf.d/
# ADD  nginx    /etc/init.d/
# RUN  chmod a+x /etc/init.d/nginx;
# RUN  ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx
# ADD  run.sh    /
# RUN  chmod a+x /run.sh;
# ENTRYPOINT ["/run.sh"]

# # RUN  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# # CMD ["/run.sh"]
# # CMD ["/etc/docker-entrypoint.sh", "/usr/local/nginx/sbin/nginx"]
# # ENTRYPOINT ["docker-entrypoint.sh /usr/local/nginx/sbin/nginx"]

# # nginx:80 php-fpm:9000
# EXPOSE 80 9000
# VOLUME ["/data1"]




# # ADD sources.list    /etc/apt/sources.list
# # # 安装modules
# # RUN apt-get update && apt-get install -y \
# #         #libxml2-dev \
# #         libfreetype6-dev \
# #         libmemcached-dev \
# #         libmcrypt-dev \
# #         libjpeg62-turbo-dev \
# #         libpng12-dev \
# #         unzip \
# #         && docker-php-ext-install -j$(nproc) iconv mcrypt \
# #         && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
# #         && docker-php-ext-install -j$(nproc) gd \
# #         && docker-php-ext-install mysqli \
# #         && docker-php-ext-install pdo_mysql \
# #         && docker-php-ext-install opcache \
# #         #&& docker-php-ext-install zip \
# #         && pecl install channel://pecl.php.net/xhprof-0.9.4 \
# #         && docker-php-ext-enable xhprof \
# #         && pecl install xdebug \
# #         && docker-php-ext-enable xdebug \
# #         && pecl install redis \
# #         && docker-php-ext-enable redis
# # RUN docker-php-ext-install mysql
# # ADD php.ini    /usr/local/etc/php/php.ini
# # ADD php-fpm.conf    /usr/local/etc/php-fpm.conf




# # # # 安装 Xdebug
# # # RUN curl -fsSL 'https://xdebug.org/files/xdebug-2.4.0.tgz' -o xdebug.tar.gz \
# # #     && mkdir -p xdebug \
# # #     && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
# # #     && rm xdebug.tar.gz \
# # #     && ( \
# # #     cd xdebug \
# # #     && phpize \
# # #     && ./configure --enable-xdebug \
# # #     && make -j$(nproc) \
# # #     && make install \
# # #     ) \
# # #     && rm -r xdebug \
# # #     && docker-php-ext-enable xdebug
# # # #配置 debugger
# # # RUN echo "xdebug.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# # # RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# # # RUN echo "xdebug.remote_host=192.168.99.100" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


# # WORKDIR /data1

# # RUN usermod -u 1000 www-data
# # RUN  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# # EXPOSE 9000
# # VOLUME ["/data1"]
