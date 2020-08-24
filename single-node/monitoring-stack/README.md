# Monitoring-stack-Installation
### Installation of Prometheus, Loki, Grafana at Manager node
```sh
# Zookeeper + Prometheus + Loki + Grafana
./install.sh
```
### Installation of Node-Exporter and Promtail 
Done Through Ansible. Refer [here](https://github.com/abhilashvenkatesh/iudx-deployment/tree/master/single-node/monitoring-stack/ansible#ansible)

## Description
 install.sh  creates random Grafana admin password and installs Prometheus, Loki, Grafana (with the generated admin password) using docker-compose of "manager-infra.yml".
Then, install.sh calls another script "grafana_users_install.sh"  which creates (by default 2, can be changed by passing no as parameter) Grafana users with one user as editor and all others as viewer access roles. The Grafana admin and user details are saved in secrets.txt during installation.

## Note  
1. Change the overlay network name "calc-net" in compose file : "manager-infra.yml" to appropriate overlay network.
2. Grafana creates admin credentials from its environment variables when it is run for the
   first time, and the password is saved to db (i.e. grafana-volume). Subsequent
   running/restarting the docker with new admin credentials doesn't overwrite
   the password stored in Grafana db.
