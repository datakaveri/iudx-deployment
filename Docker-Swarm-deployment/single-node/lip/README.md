# Introduction
Docker swarm stack for Latest Ingestion pipeline (LIP) Deployment.

# Installation Latest ingestion pipeline server
## Create secret files
1. Make a copy of sample secrets directory .
```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.lip.env file with appropriate values in the place holders “<>”

3. secrets directory after generation of secret files
```sh
secrets/
├── config.json
└── .lip.env
```
## Assign node labels
 The lip container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add lip-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `lip-stack.resources.yaml` for latest ingestion pipeline as shown in sample resource-values stack file for [here](example-lip-stack.resources.yaml)

## Deploy
Deploy Latest Ingestion Pipeline server:
```sh
docker stack deploy -c lip-stack.yaml -c lip-stack.resources.yaml lip
```

# NOTE
1. The upstream code for latest ingestion pipeline is available at https://github.com/datakaveri/latest-ingestion-pipeline/tree/master/vertx.
