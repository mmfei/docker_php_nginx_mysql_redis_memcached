FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/nginx/sbin

EXPOSE 1935
EXPOSE 80

# create directories
RUN mkdir /src /config /logs /data /static

# update and upgrade packages
# ffmpeg
# nginx dependencies

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get clean && \
  apt-get install -y --no-install-recommends build-essential \
  wget software-properties-common && \
  add-apt-repository ppa:mc3man/trusty-media && \
  apt-get update && \
  apt-get install -y --no-install-recommends ffmpeg && \
  apt-get install -y --no-install-recommends libpcre3-dev \
  zlib1g-dev libssl-dev wget && \
  rm -rf /var/lib/apt/lists/*

# get nginx source
# get nginx-rtmp module

WORKDIR /src
RUN wget http://nginx.org/download/nginx-1.7.5.tar.gz && \
  tar zxf nginx-1.7.5.tar.gz && \
  rm nginx-1.7.5.tar.gz && \
  wget https://github.com/arut/nginx-rtmp-module/archive/v1.1.6.tar.gz && \
  tar zxf v1.1.6.tar.gz && \
  rm v1.1.6.tar.gz

# compile nginx
WORKDIR /src/nginx-1.7.5
RUN ./configure --add-module=/src/nginx-rtmp-module-1.1.6 \
  --conf-path=/config/nginx.conf \
  --error-log-path=/logs/error.log \
  --with-http_stub_status_module \
  --http-log-path=/logs/access.log && \
  make && \
  make install

ADD nginx.conf /config/nginx.conf
ADD locations.conf /config/locations.conf
ADD sites-enabled/* /config/sites-enabled/
ADD static /static

WORKDIR /
CMD "nginx"
