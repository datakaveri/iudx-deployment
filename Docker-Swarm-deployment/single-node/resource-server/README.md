# Install
 Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.
## Required secrets
```sh
secrets/
└── configs
    ├── config-depl.json
    ├── config-dev.json
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into rs directory i.e. ```cp -r example-secrets/secrets .```  for demo or local testing purpose only! For other environment, please generate strong passwords. Please refer - https://github.com/datakaveri/iudx-resource-server/blob/3.5.0/configs/config-depl.json for latest config and 3.5.0 branch  setup.md.

## Assign node labels
 The rs container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add rs-node=true <node_name>
```
## Pre-requisites for deploying resource server
1. For running the vertx clustered resource server, need to bring zookeeper in docker swarm as mentioned [here](../zookeeper/README.md).
The  docker image ```ghcr.io/datakaveri/rs-dev:tag``` deploys a non-clustered vertx resource server.
2. Define environment file ```.rs.env```. An example env file is present [here](example-env). 
3. Elasticserach db needs to be deployed and setup accordingly for resource server use.
4. Immudb needs to be deployed and setup for resource server use. 
5. Postgres needs to be deployed and setup for resource server use.
6. Rabbitmq needs to be deployed and setup for resource server use.
7. Redis server to be deployed and setup accordingly for resource server use.
8. AAA server needs to be deployed.
9. Catalogue server needs to be deployed.

## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c rs-stack.yaml rs 
```
2. Setting resource reservations,limits in 'rs-stack.resources.yaml' file and then deploying (see [here](example-rs-stack.resources.yaml) for example configuration of 'rs-stack.resources.yaml' file ). Its suitable for production environment.

```sh
docker stack deploy -c rs-stack.yaml -c rs-stack.resources.yaml rs
```
3. You can add more custom stack cofiguration in file 'rs-stack.custom.yaml' that overrides base 'rs-stack.yaml' file like ports mapping etc ( see [here](example-rs-stack.custom.yaml) for example configuration of 'rs-stack.custom.yaml' file)  and bring up like as follows. It is suitable for trying out locally,dev, staging and testing environment where some custom configuration such as host port mapping is needed.
```sh
docker stack deploy -c rs-stack.yaml  -c rs-stack.custom.yaml rs
```
or 
with resource limits, reservations
```sh
docker stack deploy -c rs-stack.yaml -c rs-stack.resources.yaml -c rs-stack.custom.yaml rs
```
# NOTE
1. The upstream code for resource server is available at [here](https://github.com/datakaveri/iudx-resource-server).

