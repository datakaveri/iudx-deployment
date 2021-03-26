#!/bin/bash
set -e
apt-get update &> /dev/null
apt upgrade -y &> /dev/null
apt-get install -y --no-install-recommends \
net-tools iputils-ping dnsutils htop vim &> /dev/null
echo "installed 'net-tools iputils-ping dnsutils htop vim' packages at host: `hostname`"

apt-get install -y --no-install-recommends  apt-transport-https ca-certificates \
curl gnupg-agent software-properties-common  &> /dev/null 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &> /dev/null
apt-key fingerprint 0EBFCD88  &> /dev/null 
add-apt-repository -y    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" &> /dev/null 
apt-get update  &> /dev/null

apt-get install -y --no-install-recommends \
docker-ce docker-ce-cli \
containerd.io docker-compose  &> /dev/null 

echo "Docker installation is done at host:'`hostname`'"
