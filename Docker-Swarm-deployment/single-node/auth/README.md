# Install
 Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.
## Required secrets
```sh
secrets/
└── configs
    ├── config.json
    ├── config-dev.json
└── keystore.jks
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into auth  directory  for demo or local testing purpose only! For other environment, please generate strong passwords. For seting up the keystore.jks please refer [here](https://github.com/datakaveri/iudx-aaa-server#jwt-signing-key-setup)

## Assign node labels
 The auth container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add auth-node=true <node_name>
```

## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c auth-stack.yml auth 
```
2. Setting resource reservations,limits in 'auth-stack.resources.yml' file and then deploying (see [here](example-auth-stack.resources.yml) for example configuration of 'auth-stack.resources.yml' file ). Its suitable for production environment.

```sh
docker stack deploy -c auth-stack.yml -c auth-stack.resources.yml auth
```
3. You can add more custom stack cofiguration in file 'auth-stack.custom.yml' that overrides base 'auth-stack.yml' file like ports mapping etc ( see [here](example-auth-stack.custom.yml) for example configuration of 'auth-stack.custom.yml' file)  and bring up like as follows. It is suitable for trying out locally,dev, staging and testing environment where some custom configuration such as host port mapping is needed.
```sh
docker stack deploy -c auth-stack.yml  -c auth-stack.custom.yml auth
```
or 
with resource limits, reservations
```sh
docker stack deploy -c auth-stack.yml -c auth-stack.resources.yml -c auth-stack.custom.yml auth
```