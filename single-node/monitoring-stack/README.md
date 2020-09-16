# Monitoring-stack-Installation
## Steps to install entire Monitoring-stack
1. The node where the monitoring stack needs to be installed needs to labeled as follows:
```sh
docker node update --label-add monitoring_node=true
```
2. Run the following script at swarm manager node:
```sh
# Zookeeper + Prometheus + Loki + Grafana + Promtail+ Vertx_SD
./install.sh
```
### Installation of Node-Exporter
Done Through Ansible. Refer [here](https://github.com/abhilashvenkatesh/iudx-deployment/tree/master/single-node/monitoring-stack/ansible#ansible)

## Description
 - install.sh  creates random Grafana admin password in docker secrets  
- ``` docker stack deploy -c mon_stack.yml mon_stack ``` from install.sh.
 installs Zookeeper, Vertx_SD, Prometheus, Loki, Grafana swarm services with replicas as one at node with "node.labels.monitoring_node==true" .
- Promtail service installed in global mode i.e. all nodes have one promtail task running.
- Then, install.sh calls another script "grafana_users_install.sh"  which creates (by default 2, can be changed by passing no as parameter) Grafana users with one user as editor and all others as viewer access roles. 
- The Grafana admin and user details are saved in secrets.txt during installation.


## Note  

1. Grafana creates admin credentials from its environment variables when it is run for the
   first time, and the password is saved to db (i.e. grafana-volume). Subsequent
   running/restarting the docker with new admin credentials doesn't overwrite
   the password stored in Grafana db.
2. Pipeline stages might be different for each application , this can be done using [match stage](https://grafana.com/docs/loki/latest/clients/promtail/stages/match/)
3. mon_stack.yml contains additional service vertx_sd, which discover vertx instances from zookeeper for prometheus
