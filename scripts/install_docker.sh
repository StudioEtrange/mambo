#!/bin/bash


# uninstall older/other version
# apt remove docker docker-engine docker.io containerd runc

apt update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key list
apt install -y apt-transport-https ca-certificates curl software-properties-common
#add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"

# for ubuntu 19.10 issue with containerd.io --> use nightly build because containerd.io not available in stable
#https://askubuntu.com/a/1212388 https://forums.docker.com/t/containerd-package-missing-in-debian-stretch-repository/82581/8
# add nightly build to fix problem about  containerd.io missiing on some ubuntu versions
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable nightly" 


apt update
apt-cache policy | grep http | awk '{print $2 $3}' | sort -u
apt install -y docker-ce-cli
apt install -y docker-ce


# for ubuntu 19.10 issue with containerd.io
add-apt-repository --remove "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable nightly" 
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"
apt update
apt-cache policy | grep http | awk '{print $2 $3}' | sort -u


systemctl status  webmin