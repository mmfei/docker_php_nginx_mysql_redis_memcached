# Dockerfile - CentOS 7
# https://github.com/openresty/docker-openresty

FROM centos:7

MAINTAINER Evan Wies <evan@neomantra.net>

# Docker Build Arguments
ARG RESTY_VERSION="1.11.2.5"
ARG RESTY_LUAROCKS_VERSION="2.3.0"
ARG RESTY_OPENSSL_VERSION="1.0.2k"
ARG RESTY_PCRE_VERSION="8.40"
ARG RESTY_J="1"
ARG RESTY_CONFIG_OPTIONS="\
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    "
ARG RESTY_CONFIG_OPTIONS_MORE=""

# These are not intended to be user-specified
ARG _RESTY_CONFIG_DEPS="--with-openssl=/tmp/openssl-${RESTY_OPENSSL_VERSION} --with-pcre=/tmp/pcre-${RESTY_PCRE_VERSION}"


# 1) Install yum dependencies
# 2) Download and untar OpenSSL, PCRE, and OpenResty
# 3) Build OpenResty
# 4) Cleanup

RUN yum install wget -y && rm -rf /etc/yum.repos.d/* && wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo; yum clean all;yum makecache;
RUN yum install -y pcre-devel wget net-tools gcc zlib zlib-devel make openssl-devel
ADD http://nginx.org/download/nginx-1.8.0.tar.gz
RUN tar zxvf nginx-1.8.0.tar.gz .
RUN mkdir -p /usr/local/nginx
RUN cd nginx-1.8.0 && ./configure --prefix=/usr/local/nginx && make && make install
RUN rm -vf /usr/local/nginx/conf/nginx.conf

EXPOSE 80
