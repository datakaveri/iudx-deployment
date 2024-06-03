# Introduction
Docker swarm stack for IUDX rs-server Deployment

## Pre-requisites
Deploy [Delete-script](../rs-delete-subs-script/) before resource-server

# Installation of Resource server
## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.rs.env file with appropriate values in the place holders “<>”
3. Secrets directory after generation of secret files
```sh
secrets/
├── config.json
└── .rs.env
```


## Assign node labels
 
The rs container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add rs-node=true <node_name>
```


## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of rs-server 
- RAM of rs-server
- PID limit of rs-server
in `rs-stack.resources.yaml` as shown in sample resource-values file for [here](example-rs-stack.resources.yaml)

## Deploy
Deploy resource server:
```sh
docker stack deploy -c rs-stack.yaml -c rs-stack.resources.yaml rs
```
The apis documentation will be available at https://<rs-server-domain-name>/apis
# NOTE
1. The upstream code for resource server is available at [here](https://github.com/datakaveri/iudx-resource-server).

2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-rs-stack.custom.yaml) for example configuration of 'rs-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c rs-stack.yaml -c rs-stack.resources.yaml -c rs-stack.custom.yaml rs
```
This is generally useful in local,dev/test environment.
