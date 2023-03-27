# Introduction
Docker swarm stack for Auditing server Deployment.

# Installation of Auditing server
## Create secret files
1. Make a copy of sample secrets directory 
```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.auditing.env file with appropriate values in the place holders “<>”

3. Secrets directory after generation of secret files
```sh
secrets/
├── .auditing.env
├── config.json
```

## Assign node labels
 The auditing container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add auditing-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `auditing-stack.resources.yaml` for auditing server as shown in sample resource-values stack file for [here](example-auditing-stack.resources.yaml)

## Deploy
Deploy auditing server:
```sh
docker stack deploy -c auditing-stack.yaml -c auditing-stack.resources.yaml auditing
```
# NOTE
1. The upstream code for auditing (auditing) server is available at https://github.com/datakaveri/iudx-auditing-server.
2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-auditing-stack.custom.yaml) for example configuration of 'auditing-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c auditing-stack.yaml -c auditing-stack.resources.yaml -c auditing-stack.custom.yaml auditing
```
