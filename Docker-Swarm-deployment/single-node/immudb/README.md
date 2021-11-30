# Install
## Required secrets
```sh
secrets
|-- passwords
   |-- adminpassword
   |-- rspassword
   |-- authpassword
   `-- catpassword
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into root database directory  for demo or local testing purpose only! For other environment, please generate strong passwords.

## Build the docker file

```sh
docker build -t immudbconfiggenerator .
```

## Creating an overlay network
```sh
docker network create --driver overlay overlay-net
```

## Assign node labels
 The immudb container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add immudb_db_node=true <node_name>
```

## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c immu-db-stack.yml immudb 
```
2. Setting resource reservations,limits in 'immudb-stack.resources.yml' file and then deploying (see [here](example-immudb-stack.resources.yml) for example configuration of 'immudb-stack.resources.yml' file ).

```sh
docker stack deploy -c immu-db-stack.yml -c immudb-stack.resources.yml immudb
```
3. You can add more custom stack cofiguration in file 'immudb-stack.custom.yml' that overrides base 'immudb-stack.yml' file like ports mapping etc ( see [here](example-immudb-stack.custom.yml) for example configuration of 'immudb-stack.custom.yml' file)  and bring up like as follows
```sh
docker stack deploy -c immu-db-stack.yml  -c immudb-stack.custom.yml immudb
```
or 
with resource limits, reservations
```sh
docker stack deploy -c immu-db-stack.yml -c immudb-stack.resources.yml -c immudb-stack.custom.yml immudb
```

Bring up the config and basic schema generator stack(only on clean deployment),
```sh
docker stack deploy -c immudb-config-generator.yml tmp 

# Monitor logs to ensure creation
docker service logs tmp_immudbconfiggenerator -f

# Remove stack
docker stack rm tmp 
```
