# Monstack-Installation
## Manager Node
### Installation of Prometheus, Loki, Grafana
```sh
# Zookeeper + Prometheus + Loki + Grafana
./install.sh
```
### Installation of Node-Exporter and Promtail 
Done Through Ansible. Refer [here](https://github.com/abhilashvenkatesh/iudx-deployment/tree/master/single-node/monitoring-stack/ansible#ansible)

## Description
 install.sh  creates random Grafana admin password and installs Prometheus, Loki, Grafana (with the generated admin password) using docker-compose.
Then, install.sh calls another script grafana_users_install.sh  which creates (by default 2) Grafana users ( can be changed by passing parameter),  with one user as editor and all others as viewer access roles. The Grafana admin and user details are saved in secrets.txt after installation.


