# CENTRALIZED NGINX

Following deployments assume, there is a docker swarm and docker overlay network called "overlay-net" in the swarm.

## Project structure
```sh
.
|-- .env
|-- .gitignore
|-- README.md
|-- conf
|   |-- nginx.conf
|   |-- default.conf    
|   |-- keycloak.conf
|   |-- fs.conf
|   |-- rs.conf
|   |-- auth.conf
|   |-- cat.conf 
|-- secrets
|    |-- fullchain.pem
|    |-- privkey.pem
|-- nginx-stack.yaml
|-- nginx-stack.resources.yaml 
|-- nginx-stack.custom.yaml 
```

# Install

## Required secrets

```sh
secrets/
├── fullchain.pem
├── privkey.pem

```
   Please see the ``example-secrets`` directory to get more idea, can use the ``secrets`` in that directory by copying into root keycloak directory i.e. ``cp -r example-secrets/secrets/ .`` for demo or local testing purpose only! For other environment, please generate strong passwords.

## Create Environment file
Add env variables in .env file using the template shown below

```sh
NGINX_ENVSUBST_TEMPLATE_DIR=/etc/nginx/templates
NGINX_ENVSUBST_TEMPLATE_SUFFIX=.template
NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/conf.d

SERVICE_PORT=8080
SERVER_PROTOCOL=http

KEYCLOAK_DOMAIN_NAME=keycloak.io.test
KEYCLOAK_SERVICE_NAME=keycloak


FILE_DOMAIN_NAME=fs.io.test
FILE_SERVICE_NAME=fs

RS_DOMAIN_NAME=rs.io.test
RS_SERVICE_NAME=calc

AUTH_DOMAIN_NAME=auth.io.test
AUTH_SERVICE_NAME=auth

CAT_DOMAIN_NAME=cat.io.test
CAT_SERVICE_NAME=cat
```

## Assign node labels

The Centralized-Nginx container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add centralized-nginx=true <node_name>
```

## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c nginx-stack.yaml nginx.

```

2. Setting resource reservations,limits in 'nginx-stack.resources.yaml' file and then deploying (see [here](example-nginx-stack-resources.yaml) for example configuration of 'nginx-stack-resources.yaml' file ).

```sh
docker stack deploy -c nginx-stack.yaml -c nginx-stack.resources.yaml nginx
```
3. You can add more custom stack configuration in file 'nginx-stack-custom.yaml' that overrides base 'nginx-stack.yaml' file like ports mapping etc ( see [here](example-nginx-stack-custom.yaml) for example configuration of 'nginx-stack-custom.yaml' file)  and bring up like as follows.

```sh
docker stack deploy -c nginx-stack.yaml  -c nginx-stack-custom.yaml nginx
```
or 
with resource limits, reservations
```sh
docker stack deploy -c nginx-stack.yaml -c nginx-stack.resources.yaml -c nginx-stack.custom.yaml nginx
```


# Configuration

### Limit total active connections
```sh
limit_conn_zone $server_name zone=<server-name>_conn_total:<size>;
limit_conn <server-name>_conn_total <max-number-of-active-connections-to-CAT>;
```
### Limit active connections per IP
```sh
limit_conn_zone $binary_remote_addr zone=<server-name>_conn_per_ip:<size>;
limit_conn <server-name>_conn_per_ip <max-number-of-active-connections-to-CAT-per-IP>;
```
### Limit overall request rate
```sh
limit_req_zone $server_name zone=<server-name>_req_total:<size> rate=<max-request-rate-to-CAT>;
limit_req zone=<server-name>_req_total burst=<number-of-burst-requests-allowed> nodelay;
```
### Limit request rate per IP
```sh
limit_req_zone $binary_remote_addr zone=<server-name>_req_per_ip:<size> rate=<max-request-rate-to-CAT-per-IP>r/s;
limit_req zone=<server-name>_req_per_ip burst=<number-of-burst-requests-allowed> nodelay;
```


# Note 
  * Don't use nginx 1.19 (mainline) experimental features as it might contain bugs.
