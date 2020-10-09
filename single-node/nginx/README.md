# NGINX
## Project structure
```sh
.
|-- README.md
|-- cat-nginx.yml
|-- conf
|   |-- cat.conf
|   `-- rs.conf
|-- rs-nginx.yml
`-- secrets
    |-- cat-cert
    |-- cat-key
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

# Install

## Required secrets
```sh
secrets
|-- cat-cert
|-- cat-key
|-- rs-cert
`-- rs-key
```

## Node labels
On a docker-swarm master node, run
```sh
# Label the Resource Server NGINX node
docker node update --label-add rs_nginx_node=true <hostname/ID>

# Label the Catalogue Server NGINX node
docker node update --label-add cat_nginx_node=true <hostname/ID>
```

## Deploy
On a docker-swarm master node, run
```sh
# Deploy stack
docker stack deploy -c rs-nginx.yml rs-nginx.yml
docker stack deploy -c cat-nginx.yml cat-nginx

# Remove stack
docker stack rm rs-nginx
docker stack rm cat-nginx
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

## Catalogue Server
### Limit total active connections
```sh
limit_conn_zone $server_name zone=cat_conn_total:<size>;
limit_conn cat_conn_total <max-number-of-active-connections-to-CAT>;
```
### Limit active connections per IP
```sh
limit_conn_zone $binary_remote_addr zone=cat_conn_per_ip:<size>;
limit_conn cat_conn_per_ip <max-number-of-active-connections-to-CAT-per-IP>;
```
### Limit overall request rate
```sh
limit_req_zone $server_name zone=cat_req_total:<size> rate=<max-request-rate-to-CAT>;
limit_req zone=cat_req_total burst=<number-of-burst-requests-allowed> nodelay;
```
### Limit request rate per IP
```sh
limit_req_zone $binary_remote_addr zone=cat_req_per_ip:<size> rate=<max-request-rate-to-CAT-per-IP>r/s;
limit_req zone=cat_req_per_ip burst=<number-of-burst-requests-allowed> nodelay;
```
