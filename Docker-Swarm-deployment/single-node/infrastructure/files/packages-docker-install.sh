#!/bin/bash
set -e
apt-get update &> /dev/null
apt upgrade -y &> /dev/null
apt-get install -y --no-install-recommends \
net-tools iputils-ping dnsutils htop vim &> /dev/null
echo "installed 'net-tools iputils-ping dnsutils htop vim' packages at host: `hostname`"

apt-get install -y --no-install-recommends \
ca-certificates curl gnupg  &> /dev/null 
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update  &> /dev/null

apt-get install -y --no-install-recommends \
docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null 

echo "Docker installation is done at host:'`hostname`'"
