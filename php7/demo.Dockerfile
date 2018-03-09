FROM centos:7
MAINTAINER "Linhua Tang" <linhua@staff.weibo.com>

ENV VERSION 1.0.0
ENV OPENRESTY_VERSION 1.9.7.3
ENV OPENRESTY_PREFIX /usr/local
ENV NGINX_PREFIX /usr/local/nginx
ENV VAR_PREFIX /var/nginx
ENV LOG_PREFIX /var/nginx/logs
ENV CONF_PATH /usr/local/nginx/conf/nginx.conf
ENV PHP_VERSION 7.2.0
ENV TMP_PATH /tmp/uve_core_install

COPY php7/ext $TMP_PATH

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;\
readonly NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1); \
echo "NPROC=$NPROC"; \
echo "Installing packages..."; \
yum install -y gcc gcc-c++ automake autoconf wget git bzip2 bzip2-devel libjpeg-devel libvpx-devel freetype-devel libpng-devel libmcrypt-devel libXpm-devel pcre pcre-devel openssl openssl-devel gd gd-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel curl curl-devel libcurl libcurl-devel wget zlib zlib-devel; \
echo "Downloading openresty..."; \
curl -sSL http://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz | tar -xvz; \
cd openresty-${OPENRESTY_VERSION}; \
./configure \
    --prefix=$OPENRESTY_PREFIX \
    --user=gateway \
    --group=gateway \
    --http-client-body-temp-path=$VAR_PREFIX/client_body_temp \
    --http-proxy-temp-path=$VAR_PREFIX/proxy_temp \
    --http-log-path=$LOG_PREFIX/access.log \
    --error-log-path=$LOG_PREFIX/error.log \
    --pid-path=$VAR_PREFIX/nginx.pid \
    --lock-path=$VAR_PREFIX/nginx.lock \
    --conf-path=$CONF_PATH \
    --with-luajit \
    --with-ipv6 \
    --with-http_stub_status_module \
    --with-pcre \
    --with-http_realip_module \
    --with-http_ssl_module \
    --without-http_ssi_module \
    --without-http_userid_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    -j${NPROC}; \
 echo "Building..."; \
 make -j${NPROC}; \
 echo "Installing..."; \
 make install; \
echo "Add gateway user..."; \
useradd -M -s /sbin/nologin gateway; \
echo "Clean..."; \
cd ..; \
rm -rf openresty-${OPENRESTY_VERSION}; \
echo "Install PHP"; \
cd $TMP_PATH; \
tar xjf libmcrypt-2.5.8.tar.bz2; \
cd libmcrypt-2.5.8; \
./configure; \
make -j${NPROC}; \
make install; \
cd $TMP_PATH; \
echo "Install MHash..."; \
tar xjf mhash-0.9.9.9.tar.bz2; \
cd mhash-0.9.9.9; \
./configure; \
make -j${NPROC}; \
make install; \
cd $TMP_PATH; \
echo "Install PHP7..."; \
wget http://cn2.php.net/get/php-${PHP_VERSION}.tar.bz2/from/this/mirror -O php-${PHP_VERSION}.tar.bz2; \
tar xjf php-${PHP_VERSION}.tar.bz2; \
cd php-${PHP_VERSION}; \
echo "Configure PHP..."; \
./configure --prefix=/usr/local/php7 --enable-fpm --with-fpm-user=gateway --with-fpm-group=gateway --enable-phpdbg --enable-phpdbg-webhelper --with-openssl  --with-zlib --enable-calendar --enable-bcmath --with-bz2 --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-gettext --enable-mbstring --disable-mbregex --with-mcrypt --with-mysqli --enable-pcntl --enable-shmop --enable-sockets --enable-sysvsem --enable-shmop --with-mhash; \
echo "Compiling PHP..."; \
make -j${NPROC}; \
make install; \
cd $TMP_PATH; \
echo "Install Libmemcached..."; \
tar xzf libmemcached-1.0.18.tar.gz; \
cd libmemcached-1.0.18; \
./configure; \
make -j${NPROC}; \
make install; \
cd $TMP_PATH; \
echo "Intall PHP Memcached Extension..."; \
git clone https://github.com/php-memcached-dev/php-memcached.git; \
cd php-memcached; \
git checkout php7; \
/usr/local/php7/bin/phpize; \
./configure --enable-memcached --with-php-config=/usr/local/php7/bin/php-config --disable-memcached-sasl; \
make -j${NPROC}; \
make install; \
cd $TMP_PATH; \
echo "Install PHP Redis extension..."; \
git clone https://github.com/phpredis/phpredis.git; \
cd phpredis; \
git checkout php7; \
/usr/local/php7/bin/phpize; \
./configure --enable-redis --with-php-config=/usr/local/php7/bin/php-config; \
make -j${NPROC}; \
make install; \
cd $TMP_PATH; \
echo "Configure PHP..."; \
echo -e "[redis]\nextension = redis.so\n\n[memcached]\nextension = memcached.so\n" >> /usr/local/php7/lib/php.ini; \
rm -rf $TMP_PATH; \
rm -rf /usr/local/php7/etc; \
echo "Done";

COPY php7/php.ini /usr/local/php7/lib/php.ini
COPY php7/etc /usr/local/php7/etc

VOLUME [ "/sys/fs/cgroup", "/usr/local/nginx/conf", "/data0/nginx/htdocs", "/data0/nginx/logs" ]
CMD ["/usr/sbin/init"]
