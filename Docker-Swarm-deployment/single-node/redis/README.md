# Introduction
Docker swarm stack for Redis Deployment.
# Redis Installation
## Create secret files
1. To generate the passwords:

```console
./create-secrets.sh
```
2. Secrets directory after generation of passwords:
```sh
secrets/
└── passwords
    └── admin-password
```
## Assign node labels
 The redis container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add redis-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `redis-rejson-stack.resources.yaml`  for redis as shown in sample resource-values file for [here](example-redis-rejson-stack.resources.yaml)
## Deploy
Deploy redis stack:
```sh
docker stack deploy -c redis-rejson-stack.yaml -c redis-rejson-stack.resources.yaml redis
```

## Note
1.  The docker image 'ghcr.io/datakaveri/redis-rejson'  is tagged in accordance  to this format, ```<redis-version>:<rejson-version>```.
2. If you need to expose the redis server ports, have custom stack configuration 'redis-rejson-stack.custom.yaml' that overrides base 'redis-rejson-stack.yaml' file like ports mapping etc ( see [here](example-redis-rejson-stack.custom.yaml) for example configuration)  and bring up like as follows. It is suitable for trying out locally,dev, staging and testing environment where some custom configuration such as host port mapping is needed.
```sh
docker stack deploy -c redis-rejson-stack.yaml -c redis-rejson-stack.resources.yaml -c redis-rejson-stack.custom.yaml redis
``` 
3.  Following users using the passwords present at files in ```secrets/passwords/``` directory  are created:

| Username           | Password                                    | Role/Access                         |  Services                     |
|:-------------------:|:------------------------------------------:| :---------------------------------: |:-----------------------------:|
| default          | secrets/passwords/admin-password     |     Superuser                                            |  Used by Resource and Latest ingestion pipeline |


# ToDO
1. Improve RBAC in redis using [ACL list](https://redis.io/topics/acl), its stalled now due to following reasons:
- The vertx redis client is yet to support that new [functionality](https://github.com/vert-x3/vertx-redis-client/pull/316)
