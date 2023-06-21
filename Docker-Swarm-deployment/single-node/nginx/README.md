# CENTRALIZED NGINX with ACME.SH
* The centralised nginx acts as reverse proxy/Gateway doing TLS termination, rate limiting for all public/outward facing IUDX endpoints.
* Its modeled similar to K8s nginx ingress and routing to different IUDX servers is based on hostname. 
* Each IUDX server proxy is implemented in seperate nginx virtual server.
* [acme.sh](https://github.com/acmesh-official/acme.sh#an-acme-shell-script-acmesh) is bundled with nginx which handles automated generation and renewal of letsencrypt certificates for all configured domains using https01 challenge.
## Project structure
```sh
.
├── example-configs
│   └── conf
│       ├── default.conf
│       ├── error.conf
│       ├── grafana.conf
│       ├── keycloak.conf
│       ├── kibana.conf
│       ├── nginx.conf
│       └── cos.conf
├── example-nginx-stack.resources.yaml
├── nginx-stack.yaml
└── README.md
```

# Install

## Assign node labels

The Centralized-Nginx container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add nginx-node=true <node_name>
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `nginx-stack.resources.yaml`  for nginx as shown in sample resource-values file for [here](example-nginx-stack.resources.yaml)

## Prepare nginx configs
1. Make a copy of example-configs directory 
```
cp -r example-configs/conf .
```

2. For each nginx server configuration in conf/ (except for error.conf, default.conf file), substitute appropiate domain name next to ``server_name`` directive. 
Example:- If cos domain is ``cos-domain.iudx.org`` , then susbitiute it in conf/cos.conf as follows :
```
        server_name         cos.iudx.org;
```

3. For each domain that needs a certificate generated, add domain names in [conf/acme-config.json] (./example-configs/conf/acme-config.json)
Example:-
```json
{
    "hostnames": [
        "cos-domain.iudx.org",
        "databroker-domain.iudx.org"
    ]
}
```

## Deploy
Deploy nginx stack:
```sh
docker stack deploy -c nginx-stack.yaml -c nginx-stack.resources.yaml nginx-stack
```

# NOTE
1. The example-secrets/secrets contains localhost certificate,key. Suitable for local, dev deployment environment.
2. If you want to generate and use letsencrypt staging certificates, run the stack file with command argument `--staging`
3. The acme cron is configured to run at 12:30am every night.
4. The certificates are renewed automatically every 60 days.
5. To check certificate status in acme, exec inside the container and run `acme.sh --list`
6. For more information on acme.sh, refer [here](https://github.com/acmesh-official/acme.sh#an-acme-shell-script-acmesh)

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
