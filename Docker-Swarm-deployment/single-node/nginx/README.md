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

## Design
* Setting the domain name in a variable and an explicit DNS resolver with TTL. [Ref](https://www.nginx.com/blog/dns-service-discovery-nginx-plus/#Methods-for-Service-Discovery-with-DNS-for-NGINX-and-NGINX%C2%A0Plus)
    * NGINX re-resolves the name according to the TTL, thus handling change in IP addresses of service containers
    * NGINX startup or reload operation doesn't fail when the domain name can't be resolved
    * Round-robin loadbalancing on resolved IP addresses by default
* HTTP to HTTPS redirection
* SSL optimization
* Use of environment variables in the nginx config. 
    * Environment variables are supplied through .env file (example file
      template provided in the end)
    * Working: env variables of config  placed in  templates directory (NGINX_ENVSUBST_TEMPLATE_DIR) are subsituted with 
      values and is put in /etc/nginx directory (NGINX_ENVSUBST_OUTPUT_DIR).
    * This avoids in changing the actual config and instead it can be set as varaibles in .env file
       while deploying to various places - testing and production.
    * Env variables are supported only in  nginx docker from version 1.19.[Ref](https://hub.docker.com/_/nginx)

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
limit_conn <server-name>_conn_total <max-number-of-active-connections-to-server>;
```
### Limit active connections per IP
```sh
limit_conn_zone $binary_remote_addr zone=<server-name>_conn_per_ip:<size>;
limit_conn <server-name>_conn_per_ip <max-number-of-active-connections-to-server-per-IP>;
```
### Limit overall request rate
```sh
limit_req_zone $server_name zone=<server-name>_req_total:<size> rate=<max-request-rate-to-server>;
limit_req zone=<server-name>_req_total burst=<number-of-burst-requests-allowed> nodelay;
```
### Limit request rate per IP
```sh
limit_req_zone $binary_remote_addr zone=<server-name>_req_per_ip:<size> rate=<max-request-rate-to-server-per-IP>r/s;
limit_req zone=<server-name>_req_per_ip burst=<number-of-burst-requests-allowed> nodelay;
```


# Note 
  * Don't use nginx 1.19 (mainline) experimental features as it might contain bugs.
