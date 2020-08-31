#!/bin/bash
#Requirements: docker, manager node of swarm, overlay network
# Random password generation and creation of docker secrets
export admin_passwd=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*()_+{}|:<>?=' | head -c 12) 
echo -n "$admin_passwd" | docker secret  create grafana_admin_passwd -
echo "------------Grafana_details------------" >secrets.txt
echo "admin details : username is admin and password is $admin_passwd" >>secrets.txt

mkdir  /tmp/metrics-targets
# deploying the monitoring-stack : Zookeeper, vertx_SD, Prometheus, Grafana,
# Loki, Promtail
docker stack deploy -c manager-infra-no-vertx.yml mon_stack

sleep 5 && echo "awake"
# creation of 2 grafana users
./grafana_users_install.sh 2

unset admin_passwd
