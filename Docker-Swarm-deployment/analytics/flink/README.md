# Introduction
Docker swarm stack for Flink deployment

## Flink Installation

## Assign node labels
 The flink container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add flink-node=true <node_name>
```
## Copy the secrets 
```sh
cp -r example-secrets/ .
```
## Replace the minio secrets in 
```sh
secrets/flink-tm-conf.yaml
secrets/flink-jm1-conf.yaml
secrets/flink-jm2-conf.yaml
secrets/flink-jm3-conf.yaml
```
Also replicate flink-jm*-conf file based on number of job managers we need.

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `flink-stack.resources.yaml`  for flink as shown in sample resource-values file for [here](flink-stack.resources.yaml)

## Deploy
Deploy flink stack:
```sh
docker stack deploy -c flink-stack.yaml -c flink-stack.resources.yaml flink
```

# Note
1. If you need to expose the flink management ui on a port or have custom stack configuration ( see [here](example-flink-stack.custom.yaml) for example configuration of 'flink-stack.custom.yaml' file)  and bring up like as follows
```sh
docker stack deploy -c flink-stack.yaml -c flink-stack.resources.yaml -c flink-stack.custom.yaml flink
```