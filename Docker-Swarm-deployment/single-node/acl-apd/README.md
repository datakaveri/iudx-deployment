# Introduction
Docker swarm stack for IUDX acl-apd Deployment

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
docker node update --label-add acl-apd-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `acl-apd-stack.resources.yaml` as shown in sample resource-values file for [here](example-acl-apd-server-stack.resources.yaml)

## Deploy
Deploy APD server stack:
```sh
docker stack deploy -c acl-apd-stack.yaml -c acl-apd-stack.resources.yaml acl-apd
```
The apis documentation will be available at https://<acl-apd-server-domain-name>/apis
# NOTE
1. The upstream code for acl-apd server is available at [here](https://github.com/datakaveri/iudx-acl-apd).
2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-acl-apd-server-stack.custom.yaml) for example configuration of 'acl-apd-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c acl-apd-stack.yaml -c acl-apd-stack.resources.yaml -c acl-apd-stack.custom.yaml acl-apd
```