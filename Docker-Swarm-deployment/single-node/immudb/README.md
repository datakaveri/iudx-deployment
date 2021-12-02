# Install
 Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.
## Required secrets
```sh
secrets/
└── passwords
    ├── admin-password
    ├── auth-password
    ├── cat-password
    └── rs-password
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into immudb  directory  for demo or local testing purpose only! For other environment, please generate strong passwords.

## Build the docker file
This is to create a custom docker image containing the python script to do initial setup of immudb like create users, tables required for the api-servers.
```sh
docker build -t ghcr.io/datakaveri/immudb-config-generator:1.0.5 docker/
```


## Assign node labels
 The immudb container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add immudb-node=true <node_name>
```

## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c immudb-stack.yml immudb 
```
2. Setting resource reservations,limits in 'immudb-stack.resources.yml' file and then deploying (see [here](example-immudb-stack.resources.yml) for example configuration of 'immudb-stack.resources.yml' file ). Its suitable for production environment.

```sh
docker stack deploy -c immudb-stack.yml -c immudb-stack.resources.yml immudb
```
3. You can add more custom stack cofiguration in file 'immudb-stack.custom.yml' that overrides base 'immudb-stack.yml' file like ports mapping etc ( see [here](example-immudb-stack.custom.yml) for example configuration of 'immudb-stack.custom.yml' file)  and bring up like as follows. It is suitable for trying out locally,dev, staging and testing environment where some custom configuration such as host port mapping is needed.
```sh
docker stack deploy -c immudb-stack.yml  -c immudb-stack.custom.yml immudb
```
or 
with resource limits, reservations
```sh
docker stack deploy -c immudb-stack.yml -c immudb-stack.resources.yml -c immudb-stack.custom.yml immudb
```

Bring up the config and basic schema generator stack(only on clean deployment),
```sh
docker stack deploy -c immudb-config-generator.yml tmp 

# Monitor logs to ensure creation
docker service logs tmp_immudbconfiggenerator -f

# Remove stack
docker stack rm tmp 
```
## Note
1.  The docker image 'ghcr.io/datakaveri/immudb-config-generator'  is tagged in accordance with immudb version used.
