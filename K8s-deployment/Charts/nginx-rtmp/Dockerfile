
FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/nginx/sbin

RUN mkdir -p /src /config /logs /data /opt/nginx/html /record

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get clean && \
  apt-get install -y --no-install-recommends build-essential \
  wget software-properties-common && \
  apt-get install -y --no-install-recommends ffmpeg && \
  apt-get install -y --no-install-recommends libpcre3-dev stunnel git ca-certificates openssl \
  zlib1g-dev libssl-dev wget && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN wget http://nginx.org/download/nginx-1.23.2.tar.gz && \
  tar zxf nginx-1.23.2.tar.gz && \
  rm nginx-1.23.2.tar.gz

RUN git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module

WORKDIR /src/nginx-1.23.2
RUN ./configure --add-dynamic-module=/src/nginx-rtmp-module \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/lock/nginx/nginx.lock \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/tmp/nginx-client-body \
        --with-http_ssl_module \
        --with-threads \
        --with-ipv6 && \
        make && \
        make install && \
        mkdir /var/lock/nginx

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/nginx.conf
COPY stat.xsl /opt/nginx/html/stat.xsl
EXPOSE 1935
EXPOSE 8080
EXPOSE 6060

CMD ["nginx", "-g", "daemon off;"]