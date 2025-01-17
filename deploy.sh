#!/bin/bash

source $HOME/.bash_profile $HOME/.bashrc

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo 'Restarting Go...'
cd $DIR/golang/
go build -o bin/webapp .
sudo systemctl stop web-golang.service
cp bin/webapp /home/isucon/webapp/golang/bin/
cd $DIR
sudo systemctl restart web-golang.service
echo 'Restarted!'

sudo cp $DIR/systemd/* /etc/systemd/system/
sudo systemctl daemon-reload

echo 'Updating config file...'
sudo cp "$DIR/nginx.conf" /etc/nginx/nginx.conf
# sudo cp "$DIR/redis.conf" /etc/redis/redis.conf
sudo cp "$DIR/mysqld.cnf" /etc/mysql/mysql.conf.d/mysqld.cnf
echo 'Updated config file!'

echo 'Restarting services...'
# sudo systemctl restart redis.service
sudo systemctl restart mysql.service
sudo systemctl restart nginx.service
echo 'Restarted!'

echo 'Rotating files'
sudo bash -c 'cp /var/log/nginx/access.log /var/log/nginx/access.log.$(date +%s) && echo > /var/log/nginx/access.log'
sudo bash -c 'cp /var/log/mysql/slow.sql /var/log/mysql/slow.sql.$(date +%s).$(git rev-parse HEAD) && echo > /var/log/mysql/slow.sql'
echo 'Rotated!
