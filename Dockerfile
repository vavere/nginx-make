FROM centos:7.5.1804

RUN yum install -y epel-release

RUN yum groupinstall -y 'Development Tools'

RUN yum install -y perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel libxml2 libxml2-devel gd gd-devel GeoIP GeoIP-devel google-perftools google-perftools-devel

# build sources

ADD https://www.zlib.net/zlib-1.2.11.tar.gz zlib.tar.gz
RUN tar zxvf zlib.tar.gz

ADD https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz pcre.tar.gz
RUN tar zxvf pcre.tar.gz

ADD https://www.openssl.org/source/openssl-1.1.0i.tar.gz openssl.tar.gz
RUN tar zxvf openssl.tar.gz

ADD https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz headers-more.tar.gz
RUN tar zxvf headers-more.tar.gz

ADD https://nginx.org/download/nginx-1.15.3.tar.gz nginx.tar.gz
RUN tar zxvf nginx.tar.gz

RUN rm -rf *.tar.gz

WORKDIR /nginx-1.15.3

RUN ./configure \
  --with-pcre=../pcre-8.42/ \ 
  --with-zlib=../zlib-1.2.11/ \ 
  --with-openssl=../openssl-1.1.0i/ \
  --add-module=../headers-more-nginx-module-0.33/ \
  --prefix=/usr/share/nginx \
  --sbin-path=/usr/sbin/nginx \ 
  --modules-path=/usr/lib64/nginx/modules \ 
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
  --http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
  --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
  --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
  --http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
  --pid-path=/run/nginx.pid \
  --lock-path=/run/lock/subsys/nginx \
  --user=nginx \
  --group=nginx \
  --with-file-aio \ 
  --with-http_auth_request_module \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_realip_module \
  --with-http_addition_module \ 
  --with-http_xslt_module=dynamic \
  --with-http_image_filter_module=dynamic \
  --with-http_geoip_module=dynamic \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_degradation_module \
  --with-http_slice_module \
  --with-http_stub_status_module \
  --with-http_perl_module=dynamic \
  --with-mail=dynamic \
  --with-mail_ssl_module \
  --with-pcre-jit \
  --with-stream=dynamic \
  --with-stream_ssl_module \
  --with-google_perftools_module \
  --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -m64 -mtune=generic'  

#  --with-ld-opt='-Wl,-z,relro -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -Wl,-E'

RUN make


