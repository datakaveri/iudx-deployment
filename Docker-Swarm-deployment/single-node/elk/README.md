# Introduction
Docker swarm stack for Elasticsearch-logstash-Kibana (ELK) Deployment.

## ELK Installation
## Create secret files
1. Make a copy of sample secrets directory.
```console
 cp -r example-secrets/secrets .
```
2. To generate the passwords:

```console
./create-secrets.sh
```
3. Generate Keystores
```
./generate-keystore.sh
```
4. Create S3 bucket and corresponding IAM user with programmatic access to only that bucket. Copy the access-key id and access-secret key to ``secrets/pki/s3-access-key`` and ``secrets/pki/s3-secret-key``
5. Secrets directory after generation of secrets

## Required secrets
```sh
secrets/
├── keystores
│   ├── elasticsearch.keystore
│   ├── kibana.keystore
│   └── logstash.keystore
├── passwords
│   ├── elasticsearch-cat-password
│   ├── elasticsearch-fs-password
│   ├── elasticsearch-rs-password
│   ├── elasticsearch-su-password
│   ├── kibana-admin-password
│   ├── kibana-admin-username
│   ├── kibana-system-password
│   ├── logstash-internal-password
│   ├── logstash-rabbitmq-password
│   ├── logstash-rabbitmq-username
│   └── logstash-system-password
└── pki
    ├── s3-access-key
    └── s3-secret-key
```

Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into root database directory  for demo or local testing purpose only! The kibana is tls secured through centralised nginx.

## Assign node labels

```sh
docker node update --label-add database_node=true <node_name>
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `database-stack.resources.yaml`  for elk as shown in sample resource-values file for [here](example-database-stack.resources.yaml)


## Deploy
Deploy ELK stack:
```sh
docker stack deploy -c database-stack.yaml -c database-stack.resources.yaml database
```
After few minutes, kibana console can be accessed at ``https://<kibana-domain-name>/``
## ELK Users creation
1. Bring up the account generator stack(only on clean deployment),
```sh
docker stack deploy -c account-generator.yaml tmp 
```
2. Monitor logs to ensure creation
```sh
docker service logs tmp_account-generator -f
```
3. Remove stack, once users are created
```sh
docker stack rm tmp 
```
# Note
1. If you need to expose the HTTP port of kibana or have custom stack configuration( see [here](example-database-stack.custom.yaml) for example configuration of 'database-stack.custom.yaml' file)  and bring up like as follows.

```sh
docker stack deploy -c database-stack.yaml -c database-stack.resources.yaml -c database-stack.custom.yaml database
```
This is generally useful in local, dev/test environment.


