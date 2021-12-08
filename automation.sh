#!/bin/bash
sudo apt update -y

dpkg -s apache2

if [ $? > 0 ]; then
apt-get install apache2 -y
systemctl start  apache2
systemctl enable apache2
fi

act=$(systemctl is-active apache2)
if [ "$act" != "active" ]; then
service apache2 start
fi

systemctl is-enabled apache2
if [ $? -ne 0 ]; then
systemctl enable apache2
fi

dpkg -s awscli
if [ $? -ne 0 ]; then
sudo apt install awscli -y
fi

name=kabir
dt=$(date "+%Y.%m.%d-%H.%M.%S")
tar -cvf /tmp/$name-httpd-logs-$dt.tar /var/log/apache2

#fz=$(stat -c %s "/tmp/$name-httpd-logs-$dt.tar")
fz=$(ls -l --block-size=M /tmp/$name-httpd-logs-$dt.tar | awk '{print $5}')

aws s3 cp /tmp/$name-httpd-logs-$dt.tar s3://upgrad-kabirgarhwal/$name-httpd-logs-$dt.tar
