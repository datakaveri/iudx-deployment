# Introduction
Docker swarm stack for delete script.


# Installation of refresh script
## Create secret files
1. Make a copy of sample secrets directory 
```console
 cp -r example-secrets/* .
```
2. Substitute appropriate values whatever required in secret-config files in the place holders “<>”

3. Secrets directory after generation of secret files
```sh
secrets/
└──  script-config.json

```

## Assign node labels
 The container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add delete-script-node=true <node_name>
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `delete-script.resources.yaml` for delete script as shown in sample resource-values stack file for [here](example-delete-script.resources.yaml)

# Deploy 
## Bring up container in Docker swarm overlay net

```
docker stack deploy -c delete-script.yaml -c delete-script.resources.yaml delete-script
```
