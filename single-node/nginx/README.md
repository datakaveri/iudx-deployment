# NGINX
## Project structure
```sh
nginx
|-- README.md
|-- conf
|   |-- cat.conf
|   `-- rs.conf
|-- nginx.yml
`-- secrets
    |-- cat-cert
    |-- cat-key
    |-- rs-cert
    `-- rs-key
```

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
docker stack deploy -c nginx.yml nginx

# Remove stack
docker stack rm nginx
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
limit_req zone=rs_req_total;
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
limit_req zone=cat_req_total;
```
### Limit request rate per IP
```sh
limit_req_zone $binary_remote_addr zone=cat_req_per_ip:<size> rate=<max-request-rate-to-CAT-per-IP>r/s;
limit_req zone=cat_req_per_ip burst=<number-of-burst-requests-allowed> nodelay;
```