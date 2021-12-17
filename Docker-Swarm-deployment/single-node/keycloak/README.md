# Install
Following deployments assume, there is a docker swarm and docker overlay network called "overlay-net" in the swarm. Please [refer](https://github.com/hackcoderr/iudx-deployment/blob/keycloak/docs/swarm-setup.md) to bring up docker swarm and the network.

## Required secrets

```sh
secrets/
└── passwords
    ├── keycloak_admin_user
    └── keycloak_admin_password
 ```
   Please see the ``example-secrets`` directory to get more idea, can use the 'secrets' in that directory by copying into root postgres directory i.e. ``cp -r example-secrets/secrets/`` .for demo or local testing purpose only! For other environment, please generate strong passwords. 
    
    

## PostgreSQL Installation
Before Keycloak installation, Install postgreSQL and follow this [document](https://github.com/hackcoderr/iudx-deployment/tree/keycloak/Docker-Swarm-deployment/single-node/postgres) for that.

## Deployment

[bitnami keycloak image](https://hub.docker.com/r/bitnami/keycloak/) is used for postgres.

Quick deploy
```
docker stack deploy --compose-file keycloak-stack.yml keycloak
```
