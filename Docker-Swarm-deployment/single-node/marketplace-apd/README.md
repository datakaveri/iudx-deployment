# Introduction
Docker swarm stack for IUDX dmp-apd Deployment

# Installation of APD server
## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.apd.env file with appropriate values in the place holders “<>”
3. Secrets directory after generation of secret files
```sh
secrets/
├── config.json
└── .apd.env
```
## Assign node labels
 The apd-server container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add dmp-apd-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `dmp-apd-stack.resources.yaml` as shown in sample resource-values file for [here](example-dmp-apd-server-stack.resources.yaml)

## Deploy
Deploy APD server stack:
```sh
docker stack deploy -c dmp-apd-stack.yaml -c dmp-apd-stack.resources.yaml dmp-apd
```
The apis documentation will be available at https://<dmp-apd-server-domain-name>/apis
# NOTE
1. The upstream code for dmp-apd server is available at [here](https://github.com/datakaveri/iudx-data-marketplace-apd.git).
2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-dmp-apd-server-stack.custom.yaml) for example configuration of 'dmp-apd-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c dmp-apd-stack.yaml -c dmp-apd-stack.resources.yaml -c dmp-apd-stack.custom.yaml dmp-apd
```
