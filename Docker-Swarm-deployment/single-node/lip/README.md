# Install
 Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.
## Required secrets
```sh
secrets/
└── all-verticles-configs
    ├── config-depl.json
    ├── config-dev.json
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into lip directory i.e. ```cp -r example-secrets/secrets .```  for demo or local testing purpose only! For other environment, please generate strong passwords. Please get and refer latest config from https://github.com/datakaveri/latest-ingestion-pipeline/blob/3.5.0/vertx/example-configs/config-depl.json and setup.md.
## Assign node labels
 The lip container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add lip-node=true <node_name>
```
## Pre-requisites for deploying latest ingestion pipeline
1. For running the vertx clustered latest ingestion, need to bring zookeeper in docker swarm as mentioned [here](../zookeeper/README.md).
The  docker image ```ghcr.io/datakaveri/lip-dev:tag``` deploys a non-clustered vertx latest ingestion server.
2. Rabbitmq and redis must be brought up, please refer for [redis-install](../redis/README.md), [rabbitmq-install](../rabbitmq/README.md) . Their connection details should be updated  appropriately in configs present at ```secrets/configs``` directory.
3. Define environment file ```.lip.env```. An example env file is present [here](example-env). 
## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c lip-stack.yml lip 
```
2. Setting resource reservations,limits in 'lip-stack.resources.yml' file and then deploying (see [here](example-lip-stack.resources.yml) for example configuration of 'lip-stack.resources.yml' file ). Its suitable for production environment.

```sh
docker stack deploy -c lip-stack.yml -c lip-stack.resources.yml lip
```
3. You can add more custom stack cofiguration in file 'lip-stack.custom.yml' that overrides base 'lip-stack.yml' file like ports mapping etc ( see [here](example-lip-stack.custom.yml) for example configuration of 'lip-stack.custom.yml' file)  and bring up like as follows. It is suitable for trying out locally,dev, staging and testing environment where some custom configuration such as host port mapping is needed.
```sh
docker stack deploy -c lip-stack.yml  -c lip-stack.custom.yml lip
```
or 
with resource limits, reservations
```sh
docker stack deploy -c lip-stack.yml -c lip-stack.resources.yml -c lip-stack.custom.yml lip
```
# NOTE
1. The upstream code for latest ingestion pipeline is available at https://github.com/datakaveri/latest-ingestion-pipeline/tree/master/vertx.
