# Link4Fun

It's a PoC using Nginx with Lua modules. Check it https://link4.fun.

Features:

- URL Shortener
- Markdown Editor with syntax highlight
- Snippet Editor like Pastebin

## Setup

### Docker

```sh
docker build . -t=gustavohenrique/link4fun:alpine
docker run -d --name link4fun -p 8000:80 gustavohenrique/link4fun:alpine
open http://localhost:8000
```

Use a external volume to keep saved data:

```sh
mkdir -p ~/data/{shortener,snippet,markdown}
docker run -d --name link4fun -v $HOME/data:/var/www/data -p 8000:80 gustavohenrique/link4fun:alpine
```

### Ubuntu Linux

OpenResty is a web platform that integrates the Nginx core with LuaJit.  
Follow the instructions in https://openresty.org/en/installation.html or use
the provided script:

```sh
cd lxd
bash install-openresty-ubuntu.sh
```

After install, edit the `/etc/openresty/nginx.conf` file and add:

```nginx
user myuser;
http {
  ...
  include /etc/nginx/sites-enabled/*.conf;
}
```

Remeber to grant access to `myuser` for all directories. 

```sh
sudo mkdir -p /etc/nginx/sites-enabled
sudo mkdir -p /var/www/data
sudo mkdir /var/log/nginx

sudo ln -snf $PWD/link4fun/sites-available/http /etc/nginx/sites-enabled/default
sudo ln -sn  $PWD/link4fun/sites-available /etc/nginx/
sudo ln -sn  $PWD/link4fun/html /var/www/
sudo ln -sn  $PWD/link4fun/lua /var/www/
```
