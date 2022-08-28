# Introduction
Docker swarm stack for IUDX gis interface deployment

# Installation of GIS interface server
## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands mentioned in config files.
3. Configure the secrets/.gis-api.env file with appropriate values in the place holders “<>”
4. Secrets directory after generation of secret files
```sh
secrets/
├── config.json
└── .gis-api.env
```

## Assign node labels
 The gis container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add gis-node=true <node_name>
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit
in `gis-stack.resources.yaml` as shown in sample resource-values file for [here](example-gis-stack.resources.yaml)

## Deploy
Deploy GIS interface server:
```sh
docker stack deploy -c gis-stack.yaml -c gis-stack.resources.yaml gis
```
The apis documentation will be available at https://<gis-server-domain-name>/apis
# NOTE
1. The upstream code for gis server is available at https://github.com/datakaveri/iudx-gis-interface.
2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-gis-stack.custom.yaml) for example configuration of 'gis-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c gis-stack.yaml -c gis-stack.resources.yaml -c gis-stack.custom.yaml gis
```
