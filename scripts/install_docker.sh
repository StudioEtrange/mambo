#!/bin/bash
apt update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add –
apt install apt-transport-https ca-certificates curl software-properties-common
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable" 
apt update
apt install docker-ce
