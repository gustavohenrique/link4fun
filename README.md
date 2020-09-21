## Setup

```sh
apt -y install --no-install-recommends wget gnupg ca-certificates
apt install -y openresty lua5.3 liblua5.3-dev lua-cjson unzip build-essential
git clone --depth 1 https://github.com/ledgetech/lua-resty-http.git
cp -r lua-resty-http/lib/resty /usr/local/openresty/lualib/

# edit /etc/openresty/nginx.conf
# user ubuntu;
# include /etc/nginx/conf.d/*.conf;
```
