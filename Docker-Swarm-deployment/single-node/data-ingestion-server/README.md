# Introduction
Docker swarm stack for IUDX data-ingestion (DI) server deployment

# Installation of Data-Ingestion Server
## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands mentioned in config files. 
3. Configure the secrets/.di.env file with appropriate values in the place holders “<>”
4. Secrets directory after generation of secret files
```sh
secrets/
├── config.json
└── .di.env
```
## Assign node labels
 The di container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add di-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `di-stack.resources.yaml` as shown in sample resource-values file for [here](example-di-stack.resources.yaml)

## Deploy
Deploy data-ingestion server:
```sh
docker stack deploy -c di-stack.yaml -c di-stack.resources.yaml di
```
The apis documentation will be available at https://<di-server-domain-name>/apis
# NOTE
1. The upstream code for data ingestion  server is available at https://github.com/datakaveri/iudx-data-ingestion-server.
2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-di-stack.custom.yaml) for example configuration of 'di-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c di-stack.yaml -c di-stack.resources.yaml -c di-stack.custom.yaml di
```
This is generally useful in local,dev/test environment.