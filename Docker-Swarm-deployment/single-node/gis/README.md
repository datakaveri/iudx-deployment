# Install
 Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.
## Required secrets
```sh
secrets/
└── configs
    ├── config-depl.json
    ├── config-dev.json
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into gis  directory  for demo or local testing purpose only! For other environment, please generate strong passwords. Please get and refer for latest config at https://github.com/datakaveri/iudx-gis-interface/blob/3.5.0/configs/config-dev.json and setup.md 
## Assign node labels
 The gis container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add gis-node=true <node_name>
```
## Pre-requisites for deploying gis server
1. For running the vertx clustered gis server, need to bring zookeeper in docker swarm as mentioned [here](../zookeeper/README.md).
The  docker image ```ghcr.io/datakaveri/gis-dev:tag``` deploys a non-clustered vertx data ingestion server.
2. AAA server and Catalogue server needs to up.
3. immudb server needs to be up and setup for gis server use.
4. postgres server needs to be up and setup for gis server use.
5. Define environment file ```.gis.env```. An example env file is present [here](example-env).
## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c gis-stack.yaml gis 
```
2. Setting resource reservations,limits in 'gis-stack.resources.yaml' file and then deploying (see [here](example-gis-stack.resources.yaml) for example configuration of 'gis-stack.resources.yaml' file ). Its suitable for production environment.

```sh
docker stack deploy -c gis-stack.yaml -c gis-stack.resources.yaml gis
```
3. You can add more custom stack cofiguration in file 'gis-stack.custom.yaml' that overrides base 'gis-stack.yaml' file like ports mapping etc ( see [here](example-gis-stack.custom.yaml) for example configuration of 'gis-stack.custom.yaml' file)  and bring up like as follows. It is suitable for trying out locally,dev, staging and testing environment where some custom configuration such as host port mapping is needed.
```sh
docker stack deploy -c gis-stack.yaml  -c gis-stack.custom.yaml gis
```
or 
with resource limits, reservations
```sh
docker stack deploy -c gis-stack.yaml -c gis-stack.resources.yaml -c gis-stack.custom.yaml gis
```
# NOTE
1. The upstream code for gis server is available at https://github.com/datakaveri/iudx-gis-interface.
