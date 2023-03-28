# CENTRALIZED NGINX
* The centralised nginx acts as reverse proxy/Gateway doing TLS termination, rate limiting for all public/outward facing IUDX endpoints.
* Its modeled similar to K8s nginx ingress and routing to different IUDX servers is based on hostname. 
* Each IUDX server proxy is implemented in seperate nginx virtual server.
## Project structure
```sh
.
├── conf
│   ├── auth.conf
│   ├── cat.conf
│   ├── default.conf
│   ├── di.conf
│   ├── error.conf
│   ├── fs.conf
│   ├── gis.conf
│   ├── grafana.conf
│   ├── keycloak.conf
│   ├── kibana.conf
│   ├── nginx.conf
│   └── rs.conf
├── docker
│   └── Dockerfile
├── example-nginx-stack.resources.yaml
├── example-secrets
│   └── secrets
│       ├── fullchain.pem
│       └── privkey.pem
├── nginx-stack.resources.yaml
├── nginx-stack.yaml
├── README.md
└── secrets
    ├── fullchain.pem
    └── privkey.pem

```


# Install
## Create secret files
1. Make a copy of sample secrets directory.
```console
 cp -r example-secrets/secrets .
```
2.  Generate proper wildcard LetsEncrypt certificate covering sub-domains for - resource access server, Catalogue API server, AAA server, File server, GIS server, DI server, Grafana, Kibana, Databroker and Keycloak.

3. Copy certificate files to secrets directory as shown below:

```
cp /etc/letsencrypt/live/<domain-name>/fullchain.pem  secrets/fullchain.pem

cp /etc/letsencrypt/live/<domain-name>/privkey.pem secrets/privkey.pem
```
4. Secrets directory after generation of secrets
```sh

secrets/
├── fullchain.pem (letsencrypt fullchain.pem)
├── privkey.pem   (letsencrypt privkey.pem)

```

## Assign node labels

The Centralized-Nginx container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add centralized-nginx=true <node_name>
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `nginx-stack.resources.yaml`  for nginx as shown in sample resource-values file for [here](example-nginx-stack.resources.yaml)

## Define domain names in configs
For each nginx server configuration in conf/ (except for error.conf, default.conf file), substitute appropiate domain name next to ``server_name`` directive. 
Example:- If resource server domain is ``rs.iudx.org.in`` , then susbitiute it in conf/rs.conf as follows :
```
        server_name         rs.iudx.org.in;
```

## Deploy
Deploy nginx stack:
```sh
docker stack deploy -c nginx-stack.yaml -c nginx-stack.resources.yaml nginx-stack
```

# NOTE
1. The example-secrets/secrets contains localhost certificate,key. Suitable for local, dev deployment environment.
## Configuration

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

# To Do

1. Do nginx proxy for  rabbitmq management UI.
