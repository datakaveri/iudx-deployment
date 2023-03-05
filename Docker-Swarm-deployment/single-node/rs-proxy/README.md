# Introduction
Docker swarm stack for IUDX rs-proxy Deployment

# Installation of Resource server
## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.rs-proxy.env file with appropriate values in the place holders “<>”
3. Secrets directory after generation of secret files
```sh
secrets/
├── config.json
└── .rs-proxy.env
```


## Assign node labels
 
The rs-proxy container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add rs-proxy-node=true <node_name>
```


## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of rs-proxy 
- RAM of rs-proxy
- PID limit of rs-proxy
in `rs-proxy-stack.resources.yaml` as shown in sample resource-values file for [here](example-rs-proxy-stack.resources.yaml)

## Deploy
Deploy resource server:
```sh
docker stack deploy -c rs-proxy-stack.yaml -c rs-proxy-stack.resources.yaml rs-proxy
```
The apis documentation will be available at https://\<rs-proxy-server-domain-name\>/apis
# NOTE
1. The upstream code for resource server is available at [here](https://github.com/datakaveri/iudx-rs-proxy).

2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-rs-proxy-stack.custom.yaml) for example configuration of 'rs-proxy-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c rs-proxy-stack.yaml -c rs-proxy-stack.resources.yaml -c rs-proxy-stack.custom.yaml rs-proxy
```
This is generally useful in local,dev/test environment.
