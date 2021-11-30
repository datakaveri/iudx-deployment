# Install
## Required secrets
```sh
secrets
`-- adminpassword
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into root database directory  for demo or local testing purpose only! For other environment, please generate strong passwords.
## Build the docker file
```sh
docker build -t redisrejson:6.2.5-1.0.7 docker
```
## Creating an overlay network
```sh
docker network create --driver overlay overlay-net
```
## Assign node labels
 The redis container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add redis_node=true <node_name>
```
## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c redis-rejson-stack.yml redis
```
2. Setting resource reservations,limits in 'redis-stack.resources.yml' file and then deploying (see [here](example-redis-stack.resources.yml) for example configuration of 'redis-stack.resources.yml' file ).

```sh
docker stack deploy -c redis-rejson-stack.yml -c redis-stack.resources.yml redis
```
3. You can add more custom stack cofiguration in file 'redis-stack.custom.yml' that overrides base 'redis-stack.yml' file like ports mapping etc ( see [here](example-redis-stack.custom.yml) for example configuration of 'redis-stack.custom.yml' file)  and bring up like as follows
```sh
docker stack deploy -c redis-rejson-stack.yml  -c redis-stack.custom.yml redis
```
or 
with resource limits, reservations
```sh
docker stack deploy -c redis-rejson-stack.yml -c redis-stack.resources.yml -c redis-stack.custom.yml redis
```