# Introduction
Docker swarm stack for Zookeeper Deployment.
# Zookeeper Installation
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `zookeeper-stack.resources.yaml`  for databroker as shown in sample resource-values file for [here](example-zookeeper-stack.resources.yaml)

## Assign node labels
```sh
docker node update --label-add monitoring_node=true <node_name>   
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `zookeeper-stack.resources.yaml`  for zookeeper as shown in sample resource-values file for [here](example-zookeeper-stack.resources.yaml)

## Deploy
Deploy zookeeper stack: 
```sh
docker stack deploy -c zookeeper-stack.yaml -c zookeeper-stack.resources.yaml zookeeper
```
