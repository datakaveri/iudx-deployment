# Introduction
Docker swarm stack for MinIO deployment

## MinIO Installation
## Create secret files
1. To generate the passwords:

```console
./create-secrets.sh
```
2. Secrets directory after generation of passwords:
```sh
secrets/
└── passwords
    ├── minio-username
    ├── minio-password

```
## Assign node labels
 The minio container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add minio-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `minio-stack.resources.yaml`  for minio as shown in sample resource-values file for [here](minio-stack.resources.yaml)

## Deploy
Deploy MinIO stack:
```sh
docker stack deploy -c minio-stack.yaml -c minio-stack.resources.yaml minio
```

# Note
1. If you need to expose the psql server port or have custom stack configuration ( see [here](example-minio-stack.custom.yaml) for example configuration of 'minio-stack.custom.yaml' file)  and bring up like as follows
```sh
docker stack deploy -c minio-stack.yaml -c minio-stack.resources.yaml -c minio-stack.custom.yaml minio
```
