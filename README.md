![Link4Fun](site/static/images/logo.png)
===

Link4Fun a PoC using OpenResty (Nginx + Lua). Check it https://link4.fun.

Features:

- URL Shortener
- Markdown Editor with syntax highlight
- Text Snippet like Pastebin
- Dark mode according to browser's preference
- Simple authentication using SHA256 hash password

## How it works?

### Modules

#### URL Shortener

A CSV file saved in `$data_dir/shortener` contains the long URL and the number of hits.  
Link4Fun receives an ID, read the file with the name equals this ID, increases the hits counter, and redirect to the long URL

#### Markdown Editor

It uses CodeMirror JS as editor and Marked JS to convert the Markdown syntax to HTML using Javascript.  
All files will be saved as raw Markdown in `$data_dir/markdown`. You can add the suffix **.md** in the URL to get the raw data or **.html** to get a formatted Markdown by the server-side (using the Hoedown lib) instead of formated by Marked JS.

#### Text Snippet

You can format pieces of code using the most used syntaxes supported by the Highlight JS library. All data will be saved in `$data_dir/snippet`.

#### Authentication

The username and password are defined in the Nginx configuration file. The password must be a SHA256 hash.  
There isn't support to sign up and only the authenticated user can edit contents.  
A hash can be generated running the command:

```sh
echo -ne mypassword | sha256sum
```

### Organization

```
.
├── conf/             # Nginx config files
├── site/
│   ├── static/       # images, fonts, css and javascript files
│   ├── templates/    # HTML files rendered by lua
├── lua/
│   ├── main.lua      # where the magic begins. it instanciate dependencies and inject them in the other modules
│   ├── app/          # application modules
│   ├── lib/          # application libraries and OpenResty modules
├── lxd/              # tools to help me to configure a LXD container
```

## Setup

### Docker

```sh
# make docker
docker build . -t=gustavohenrique/link4fun:alpine
docker run -d --name link4fun -p 8000:80 gustavohenrique/link4fun:alpine
open http://localhost:8000
```

Use an external volume to keep saved data:

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

After install, replace the original Nginx configuration with our custom configuration:

```sh
rm -rf /usr/local/openresty/nginx/conf
ln -snf $PWD/link4fun/conf /usr/local/openresty/nginx/conf
ln -snf $PWD/link4fun/conf/development.conf /usr/local/openresty/nginx/conf/site.conf
```

The `/var/www/data` is the place where all data will be saved. The user in `nginx.conf` must be the owner of `/var/www`.

```sh
sudo mkdir -p /var/www/data/{shortener,markdown,snippet}
sudo mkdir /var/log/nginx

# ubuntu is the user defined in link4fun/conf/nginx.conf
sudo chown ubuntu:ubuntu -Rf /var/www
sudo chown ubuntu:ubuntu -Rf /var/log/nginx

sudo ln -snf $PWD/link4fun/lua /var/www/lua
sudo ln -sn  $PWD/link4fun/site /var/www/site
```

#### Optional Harderning

```sh
# Kernel params
sudo tee -a /etc/sysctl.conf <<EOF
fs.file-max=50000                   # the number of files that a process can open concurrently
net.ipv4.tcp_max_syn_backlog = 4096 # number of connection requests did not receive an ack from client
net.core.somaxconn = 4096 # limit of socket listen() backlog

# increase the write-buffer-space allocatable
net.ipv4.tcp_wmem = 4096 65536 524288
net.core.wmem_max = 16384

net.ipv4.tcp_abort_on_overflow = 1
net.ipv4.tcp_max_tw_buckets = 1440000
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_moderate_rcvbuf = 1
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_mem  = 134217728 134217728 134217728
net.ipv4.tcp_rmem = 4096 277750 134217728
net.ipv4.tcp_wmem = 4096 277750 134217728
net.core.netdev_max_backlog = 300000
EOF

# File descriptors
sudo tee -a /etc/security/limits.conf <<EOF
ubuntu soft nofile 65535
ubuntu hard nofile 97816
EOF

# Edit /lib/systemd/system/openresty.service
# LimitNOFILE=65535
# LimitNOFILESoft=97816
# If OpenResty is running: prlimit --pid <openresty pid> --nofile=65535:97816
```

