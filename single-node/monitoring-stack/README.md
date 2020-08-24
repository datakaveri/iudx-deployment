# Monstack-Installation
## Manager Node
### Installation of Prometheus, Loki, Grafana
```sh
# Zookeeper + Prometheus + Loki + Grafana
./install.sh
```
### Installation of Node-Exporter and promtail 
Done Through Ansible. Refer [here](https://github.com/abhilashvenkatesh/iudx-deployment/tree/master/single-node/monitoring-stack/ansible#ansible)

## Description
install.sh creates random Grafana admin password and installs Prometheus, Loki, Grafana (with the generated admin password).
Then,  ```sh install.sh `` calls another script ```sh grafana_users_install.sh ``` creates by default 2 more Grafana users ( can be changed by passing parameter), 
with one user as editor and all other as viewer access roles.
