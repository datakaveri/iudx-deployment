# Install
Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.
## Required secrets
```sh
secrets
`-- admin-password
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into root database directory  for demo or local testing purpose only! For other environment, please generate strong passwords.
## Build the docker file
This builds custom docker image on top of [bitnami docker redis](https://github.com/bitnami/bitnami-docker-redis) to include [rejson](https://oss.redis.com/redisjson/) module.
```sh
docker build -t ghcr.io/datakaveri/redis-rejson:6.2.6-1.0.7 docker
```
## Assign node labels
 The redis container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add redis-node=true <node_name>
```
## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c redis-rejson-stack.yml redis
```
2. Setting resource reservations,limits in 'redis-rejson-stack.resources.yml' file and then deploying (see [here](example-redis-rejson-stack.resources.yml) for example configuration of 'redis-rejson-stack.resources.yml' file ). Its suitable for production environment.

```sh
docker stack deploy -c redis-rejson-stack.yml -c redis-rejson-stack.resources.yml redis
```
3. You can add more custom stack cofiguration in file 'redis-rejson-stack.custom.yml' that overrides base 'redis-rejson-stack.yml' file like ports mapping etc ( see [here](example-redis-rejson-stack.custom.yml) for example configuration of 'redis-rejson-stack.custom.yml' file)  and bring up like as follows. It is suitable for trying out locally,dev, staging and testing environment where some custom configuration such as host port mapping is needed.
```sh
docker stack deploy -c redis-rejson-stack.yml  -c redis-rejson-stack.custom.yml redis
```
or 
with resource limits, reservations
```sh
docker stack deploy -c redis-rejson-stack.yml -c redis-rejson-stack.resources.yml -c redis-rejson-stack.custom.yml redis
```
