# Install
Following deployments assume, there is a docker swarm and docker overlay network called "overlay-net" in the swarm. Please [refer](https://github.com/hackcoderr/iudx-deployment/blob/keycloak/docs/swarm-setup.md) to bring up docker swarm and the network.

[bitnami keycloak image](https://hub.docker.com/r/bitnami/keycloak/) is used for postgres.


## Required secrets

```sh
secrets/
└── passwords
    ├── keycloak-admin-passwd
    └── keycloak-db-passwd
 ```
   Please see the ``example-secrets`` directory to get more idea, can use the ``secrets`` in that directory by copying into root keycloak directory i.e. ``cp -r example-secrets/secrets/ .`` for demo or local testing purpose only! For other environment, please generate strong passwords. 
   
   
## Assign node labels

The keycloak container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add keycloak-node=true <node_name>
```
## Pre-requisite
1. Before Keycloak installation, Install postgreSQL and follow this [document](../postgres/README.md) for that.


## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c keycloak-stack.yaml keycloak

```

2. Setting resource reservations,limits in 'keycloak-stack.resources.yaml' file and then deploying (see [here](example-keycloak-stack-resources.yaml) for example configuration of 'keycloak-stack-resources.yaml' file ).

```sh
docker stack deploy -c keycloak-stack.yaml -c keycloak-stack.resources.yaml keycloak
```
3. You can add more custom stack configuration in file 'keycloak-stack-custom.yaml' that overrides base 'keycloak-stack.yaml' file like ports mapping etc ( see [here](example-keycloak-stack-custom.yaml) for example configuration of 'keycloak-stack-custom.yaml' file)  and bring up like as follows.

```sh
docker stack deploy -c keycloak-stack.yaml  -c keycloak-stack-custom.yaml keycloak
```
or 
with resource limits, reservations
```sh
docker stack deploy -c keycloak-stack.yaml -c keycloak-stack.resources.yaml -c keycloak-stack.custom.yaml keycloak
```

## ToDo
1. Make keycloak container with read-only [file-system](https://github.com/bitnami/bitnami-docker-keycloak/issues/31).
