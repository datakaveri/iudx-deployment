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

## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c keycloak-stack.yml keycloak
```

2. Setting resource reservations,limits in 'keycloak-stack.resources.yml' file and then deploying (see [here](example-keycloak-stack-resources.yml) for example configuration of 'keycloak-stack-resources.yml' file ).

```sh
docker stack deploy -c keycloak-stack.yml -c keycloak-stack-resources.yml keycloak
```
3. You can add more custom stack configuration in file 'keycloak-stack-custom.yml' that overrides base 'keycloak-stack.yml' file like ports mapping etc ( see [here](example-keycloak-stack-custom.yml) for example configuration of 'keycloak-stack-custom.yml' file)  and bring up like as follows.

```sh
docker stack deploy -c keycloak-stack.yml  -c keycloak-stack-custom.yml keycloak
```
or 
with resource limits, reservations
```sh
docker stack deploy -c keycloak-stack.yml -c keycloak-stack-resources.yml -c keycloak-stack-custom.yml keycloak
```



## Note
Before Keycloak installation, Install postgreSQL and follow this [document](https://github.com/hackcoderr/iudx-deployment/tree/keycloak/Docker-Swarm-deployment/single-node/postgres) for that.

