#!/bin/bash
set -e 
apt-get update > /dev/null 
apt upgrade -y > /dev/null
apt-get install -y --no-install-recommends  apt-transport-https ca-certificates \
curl gnupg-agent software-properties-common  > /dev/null 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -   
apt-key fingerprint 0EBFCD88   
add-apt-repository -y    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" > /dev/null 
apt-get update  > /dev/null
apt-get install -y --no-install-recommends docker-ce docker-ce-cli \
containerd.io docker-compose net-tools iputils-ping  > /dev/null 

echo "Docker installation is done at host:'`hostname`'"
