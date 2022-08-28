# Introduction
Docker swarm stack for IUDX file-server Deployment

# Installation of File server
## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.fs.env file with appropriate values in the place holders “<>”
3. Secrets directory after generation of secret files
```sh
secrets/
├── config.json
└── .fs.env
```
## Assign node labels
 The file-server container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add file-server-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `file-server-stack.resources.yaml` as shown in sample resource-values file for [here](example-file-server-stack.resources.yaml)

## Deploy
Deploy File server stack:
```sh
docker stack deploy -c file-server-stack.yaml -c file-server-stack.resources.yaml file-server
```
The apis documentation will be available at https://<file-server-domain-name>/apis
# NOTE
1. The upstream code for file server is available at [here](https://github.com/datakaveri/iudx-file-server).
2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-file-server-stack.custom.yaml) for example configuration of 'rs-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c file-server-stack.yaml -c file-server-stack.resources.yaml -c file-server-stack.custom.yaml file-server
```