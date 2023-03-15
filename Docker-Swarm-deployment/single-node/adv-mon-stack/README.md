# Advance Monitoing Stack

Docker swarm stack for advance monitoring stack

# Installation of Advance monitoring Stack
## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files.
3. Secrets directory after generation of secret files
```sh
secrets/
└── adv-mon-stack-conf.json
```


## Assign node labels

The ams container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add monitoring_node=true <node_name>
```


## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of ams
- RAM of ams
- PID limit of ams
in `ams-stack.resources.yaml` as shown in sample resource-values file for [here](example-ams-stack.resources.yaml)

## Deploy
Deploy resource server:
```sh
docker stack deploy -c ams-stack.yaml -c ams-stack.resources.yaml ams
```
# NOTE
1. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-ams-stack.custom.yaml) for example configuration of 'ams-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c ams-stack.yaml -c ams-stack.resources.yaml -c ams-stack.custom.yaml ams
```
This is generally useful in local,dev/test environment.
