# Monitoring-stack-Installation
## Required secrets
```sh
secrets/
|-- passwords
|   |-- grafana-super-admin-passwd
|   `-- grafana-super-admin-username
`-- pki
    |-- grafana-server-cert.pem  (letsencrpt fullchain.pem)
    `-- grafana-server-key.pem   (letsencrypt privkey.pem)
 ```
## Assign node labels 
```sh
docker node update --label-add monitoring_node=true <hostname/ID>
```
## Create .grafana.env file 
Define env variables specific to production/testing environment for Grafana in .grafana.env using following template. 
```sh
GF_SERVER_ROOT_URL=https://<domain-name>:3000/
TELEGRAM_CHAT_ID=-78222322                      # configure telegram chat ID 
TELEGRAM_BOT_TOKEN=22222920290sws               # configure Telegram bot token 
```

## Deploy

### Installation of Node-Exporter and docker daemon metrics
Done Through Ansible. Refer [here](ansible/README.md)

### Production
```sh
# Prometheus + Loki + Grafana + Promtail+ Vertx_SD (assumes zookeeper to be running)
docker stack deploy -c mon-stack.yml -c mon-stack.prod.yml  mon-stack

```
### Testing
```sh
# Prometheus + Loki + Grafana + Promtail+ Vertx_SD (assumes zookeeper to be running)
docker stack deploy -c mon-stack.yml -c mon-stack.test.yml  mon-stack

```
### Development
```sh
# Zookeeper + Prometheus + Loki + Grafana + Promtail+ Vertx_SD
docker stack deploy -c mon-stack.yml -c mon-stack.dev.yml  mon-stack
```

## Description
* ``` docker stack deploy -c mon-stack.yml -c mon-stack.prod.yml mon-stack ``` 
 installs Vertx_SD, Prometheus, Loki, Grafana swarm services with replicas as one at node with "node.labels.monitoring_node==true" .
* Promtail service installed in global mode i.e. all nodes have one promtail task running.


## Note  

1. Grafana creates super admin  when it is run for the
   first time, and the password is saved to db (i.e. grafana-volume). Subsequent
   running/restarting the docker with new admin credentials doesn't overwrite
   the password stored in Grafana db.
2. Pipeline stages might be different for each application , this can be done using [match stage](https://grafana.com/docs/loki/latest/clients/promtail/stages/match/)
3. mon-stack.yml contains additional service vertx_sd, which discover vertx instances from zookeeper for prometheus.
4. Config Telegrambot for grafana's alerts is detailed [here](https://gist.github.com/abhilashvenkatesh/50478502ccd257a28d2c441ac51a8d65).

