### Installation

```sh
rsync -r $PWD link4fun:/home/ubuntu
ssh link4fun
cd link4fun
./ubuntu.sh
mkdir -p /etc/nginx/sites-enabled
mkdir /var/www
mkdir /var/log/nginx
sudo chown ubuntu /var/log/nginx
sudo ln -snf $HOME/link4fun/sites-available/https /etc/nginx/sites-enabled/default
sudo ln -sn $HOME/link4fun/sites-available /etc/nginx/
sudo ln -sn $HOME/link4fun/html /var/www/
sudo ln -sn $HOME/link4fun/lua /var/www/
```

### Configuration

Edit `/etc/openresty/nginx.conf` and set:

- `user ubuntu;`
- `include /etc/nginx/sites-enabled/*.conf;`
