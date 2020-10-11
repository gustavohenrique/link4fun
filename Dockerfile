FROM openresty/openresty:alpine
MAINTAINER Gustavo Henrique <gustavo@gustavohenrique.net>

COPY . /link4fun

ENV NGINX_DIR /usr/local/openresty/nginx
ENV APP_DIR   /link4fun

RUN mkdir -p /var/www/data/shortener \
 && mkdir /var/www/data/snippet \
 && mkdir /var/www/data/markdown \
 && sed -ie 's,ubuntu,nobody,g' $APP_DIR/conf/nginx.conf \
 && rm -rf $NGINX_DIR/conf \
 && ln -snf $APP_DIR/conf $NGINX_DIR/ \
 && ln -snf $APP_DIR/conf/development.conf $NGINX_DIR/conf/site.conf \
 && ln -snf $NGINX_DIR/logs /var/log/nginx \
 && ln -snf $APP_DIR/site /var/www/ \
 && ln -snf $APP_DIR/lua /var/www/ \
 && chown -Rf nobody $APP_DIR \
 && chown -Rf nobody /var/www
