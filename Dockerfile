FROM openresty/openresty:alpine
MAINTAINER Gustavo Henrique <gustavo@gustavohenrique.net>

COPY . /link4fun

RUN mkdir -p /var/www/data/shortener \
 && mkdir /var/www/data/snippet \
 && mkdir /var/www/data/markdown \
 && ln -sn /usr/local/openresty/nginx/logs /var/log/nginx \
 && ln -snf /link4fun/sites-available/http /etc/nginx/conf.d/default.conf \
 && ln -sn  /link4fun/sites-available /etc/nginx/ \
 && ln -sn  /link4fun/html /var/www/ \
 && ln -sn  /link4fun/lua /var/www/ \
 && chown -Rf nobody /link4fun \
 && chown -Rf nobody /var/www
