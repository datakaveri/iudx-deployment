#!/bin/bash
export admin_passwd=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*()_+{}|:<>?=' | head -c 12)
echo "------------Grafana_details------------" >secrets.txt
echo "admin details : username is admin and password is $admin_passwd" >>secrets.txt
docker-compose -f manager-infra.yml up -d
sleep 5 && echo "awake"
./grafana_users_install.sh 2
unset admin_passwd
