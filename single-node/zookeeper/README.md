# Deployment of Zookeeper
## Assign node labels
```sh
docker node update --label-add monitoring_node=true <node_name>   
```
## Deploy
```sh
docker stack deploy -c zookeeper-single-stack.yml zookeeper
```