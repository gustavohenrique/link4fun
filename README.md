## Installation

### OpenResty

OpenResty is a web platform that integrates the Nginx core with LuaJit.  
Follow the instructions in https://openresty.org/en/installation.html.

After install, edit the `/etc/openresty/nginx.conf` file and add:

```nginx
user myuser;
http {
  ...
  include /etc/nginx/sites-enabled/*.conf;
}
```

### Link4Fun

Remeber to grant access to `myuser` for all directories. 

```sh
sudo mkdir -p /etc/nginx/sites-enabled
sudo mkdir -p /var/www/data
sudo mkdir /var/log/nginx

# git clone <this repo>
sudo ln -snf link4fun/sites-available/http /etc/nginx/sites-enabled/default
sudo ln -sn link4fun/sites-available /etc/nginx/
sudo ln -sn link4fun/html /var/www/
sudo ln -sn link4fun/lua /var/www/
```
