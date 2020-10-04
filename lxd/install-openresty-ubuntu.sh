#!/bin/bash

sudo apt -y install --no-install-recommends wget gnupg ca-certificates
wget -O - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/openresty.list
sudo apt update
sudo apt install -y openresty lua5.3 liblua5.3-dev lua-cjson unzip
git clone --depth 1 https://github.com/ledgetech/lua-resty-http.git
sudo cp -r lua-resty-http/lib/resty /usr/local/openresty/lualib/
