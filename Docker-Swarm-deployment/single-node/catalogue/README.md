# Install
 Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.
## Required secrets
```sh
secrets/
└── configs
    ├── config-depl.json
    ├── config-dev.json
└── keystore.jks
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into cat directory i.e. ```cp -r example-secrets/secrets .```  for demo or local testing purpose only! For other environment, please generate strong passwords.

## Assign node labels
 The cat container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add cat-node=true <node_name>
```
## Pre-requisites for deploying Catalogue Server
1. For running the vertx clustered Catalogue Server, need to bring zookeeper in docker swarm as mentioned [here](../zookeepeir/README.md).
The  docker image ```ghcr.io/datakaveri/cat-dev:tag``` deploys a non-clustered vertx Catalogue Server.
2. Define environment file ```.cat.env```. An example env file is present [here](./example-env). 
3. Elasticserach db needs to be deployed and setup accordingly. 
4. Auth server needs to be [deployed](../auth-server/README.md).
5. Immudb needs to be [deployed and setup for catalogue server use](../immudb/README.md).

## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c cat-stack.yaml cat 
```
2. Setting resource reservations,limits in 'cat-stack.resources.yaml' file and then deploying (see [here](example-cat-stack.resources.yaml) for example configuration of 'cat-stack.resources.yaml' file ). Its suitable for production environment.

```sh
docker stack deploy -c cat-stack.yaml -c cat-stack.resources.yaml cat
```
3. You can add more custom stack cofiguration in file 'cat-stack.custom.yaml' that overrides base 'cat-stack.yaml' file like ports mapping etc ( see [here](example-cat-stack.custom.yaml) for example configuration of 'cat-stack.custom.yaml' file)  and bring up like as follows. It is suitable for trying out locally,dev, staging and testing environment where some custom configuration such as host port mapping is needed.
```sh
docker stack deploy -c cat-stack.yaml  -c cat-stack.custom.yaml cat
```
or 
with resource limits, reservations
```sh
docker stack deploy -c cat-stack.yaml -c cat-stack.resources.yaml -c cat-stack.custom.yaml cat
```
# NOTE
1. The upstream code for Catalogue Server pipeline is available [here](https://github.com/datakaveri/iudx-catalogue-server).
