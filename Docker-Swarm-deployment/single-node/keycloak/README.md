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

## Keycloak

[bitnami keycloak image](https://hub.docker.com/r/bitnami/keycloak/) is used for postgres.

### Node labels
 
 On a docker-swarm master node, run

```
# Label the Resource Server keycloak node
docker node update --label-add keycloak_node=true <hostname/ID>
```

### Deployment

Quick deploy
```
docker stack deploy --compose-file keycloak-stack.yml keycloak
```

## Nginx
Follow this link first for deploying the nginx and then change the following staff in nginx deployment.

### Create Environment file
Add env variables in ``.env`` file using the template shown below.

```
NGINX_ENVSUBST_TEMPLATE_DIR=/etc/nginx/templates
NGINX_ENVSUBST_TEMPLATE_SUFFIX=.template
NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/
SERVER_NAME=20.204.43.118
```
