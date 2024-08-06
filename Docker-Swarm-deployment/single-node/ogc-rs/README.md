# Introduction
Docker swarm stack for OGC Resource Server Deployment

# Installation of OGC Resource server
## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.ogc-rs.env file with appropriate values in the place holders “<>”
3. Secrets directory after generation of secret files
```sh
secrets/
├── config.json
└── .ogc-rs.env
```
## Assign node labels
 The ogc resource server container is constrained to run on specific node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add ogc-rs-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `ogc-rs-stack.resources.yaml` as shown in sample resource-values file for [here](example-ogc-rs-stack.resources.yaml)

## Deploy
Deploy OGC Resource server stack:
```sh
docker stack deploy -c ogc-rs-stack.yaml -c ogc-rs-stack.resources.yaml ogc-rs
```
The apis documentation will be available at https://<ogc-rs-domain-name>/apis
# NOTE
1. The upstream code for ogc resource server is available at [here](https://github.com/datakaveri/ogc-resource-server.git).
2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-ogc-rs-stack.custom.yaml) for example configuration of 'ogc-rs-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c ogc-rs-stack.yaml -c ogc-rs-stack.resources.yaml -c ogc-rs-stack.custom.yaml ogc-rs
```