# Install
 Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.
## Required secrets
```sh
secrets/
└── configs
    ├── config.json
└── keystore-file.jks
└── keystore-rs.jks
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into file-server  directory  for demo or local testing purpose only! For other environment, please generate strong passwords. Populate .file-server-api.env environment file based on [here](example-secrets/example-env)

## Assign node labels
 The file-server container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add file-server-node=true <node_name>
```

## Pre-requisites for deploying latest ingestion pipeline
1. For running the vertx clustered latest ingestion, need to bring zookeeper in docker swarm as mentioned [here](../zookeeper/README.md).
The  docker image ```ghcr.io/datakaveri/fileserver-dev:tag``` deploys a non-clustered vertx latest ingestion server.
2. Define environment file ```.file-server.env```. An example env file is present [here](example-secrets/example-env).

## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c file-server-stack.yml file-server 
```
2. Setting resource reservations,limits in 'file-server-stack.resources.yml' file and then deploying (see [here](example-file-server-stack.resources.yml) for example configuration of 'file-server-stack.resources.yml' file ). Its suitable for production environment.

```sh
docker stack deploy -c file-server-stack.yml -c file-server-stack.resources.yml file-server
```
3. You can add more custom stack cofiguration in file 'file-server-stack.custom.yml' that overrides base 'file-server-stack.yml' file like ports mapping etc ( see [here](example-file-server-stack.custom.yml) for example configuration of 'file-server-stack.custom.yml' file)  and bring up like as follows. It is suitable for trying out locally,dev, staging and testing environment where some custom configuration such as host port mapping is needed.
```sh
docker stack deploy -c file-server-stack.yml  -c file-server-stack.custom.yml file-server
```
or 
with resource limits, reservations
```sh
docker stack deploy -c file-server-stack.yml -c file-server-stack.resources.yml -c file-server-stack.custom.yml file-server
```

# NOTE
1. The upstream code for resource server is available at [here](https://github.com/datakaveri/iudx-file-server).