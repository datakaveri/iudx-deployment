# NGINX
## Project structure
```sh
.
|-- .env
|-- .gitignore
|-- README.md
|-- conf
|   `-- rs.conf
|-- rs-nginx.yml
`-- secrets
    |-- rs-cert
    `-- rs-key

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
      provided in the directory).
    * Working: env variables of config  placed in  templates directory (NGINX_ENVSUBST_TEMPLATE_DIR) are subsituted with
      values and is put in /etc/nginx directory (NGINX_ENVSUBST_OUTPUT_DIR).
    * This avoids in changing the actual config and instead it can be set as varaibles in .env file
       while deploying to various places - testing and production.
    * Env variables are supported only in  nginx docker from version 1.19.[Ref](https://hub.docker.com/_/nginx)

# Install

## Required secrets
```sh
secrets
|-- rs-cert
`-- rs-key
```
## Required environment variables
Change the example environment file in the directory appropriately.

## Node labels
On a docker-swarm master node, run
```sh
# Label the Resource Server NGINX node
docker node update --label-add rs_nginx_node=true <hostname/ID>

```

## Deploy
On a docker-swarm master node, run
```sh
# Deploy stack
docker stack deploy -c rs-nginx.yml rs-nginx.yml

# Remove stack
docker stack rm rs-nginx
```

# Configuration

## Resource Server
### Limit total active connections
```sh
limit_conn_zone $server_name zone=rs_conn_total:<size>;
limit_conn rs_conn_total <max-number-of-active-connections-to-RS>;
```
### Limit active connections per IP
```sh
limit_conn_zone $binary_remote_addr zone=rs_conn_per_ip:<size>;
limit_conn rs_conn_per_ip <max-number-of-active-connections-to-RS-per-IP>;
```
### Limit overall request rate
```sh
limit_req_zone $server_name zone=rs_req_total:<size> rate=<max-request-rate-to-RS>;
limit_req zone=rs_req_total burst=<number-of-burst-requests-allowed> nodelay;
```
### Limit request rate per IP
```sh
limit_req_zone $binary_remote_addr zone=rs_req_per_ip:<size> rate=<max-request-rate-to-RS-per-IP>r/s;
limit_req zone=rs_req_per_ip burst=<number-of-burst-requests-allowed> nodelay;
```

# Note 
    *   Don't use nginx 1.19 (mainline) experimental features as it might
        contain bugs.

