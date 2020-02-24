#!/bin/bash

# note : have python2 as dependency !
# alternatives : https://blog.ssdnodes.com/blog/cpanel-alternatives-vps/

apt update
curl -fsSL http://www.webmin.com/jcameron-key.asc | apt-key add -
apt-key list
apt install -y apt-transport-https ca-certificates curl software-properties-common


add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib" 


apt update
apt-cache policy | grep http | awk '{print $2 $3}' | sort -u

apt install -y webmin

systemctl status  webmin

echo " ** see https://localhost:1000 with a sudo/root user"