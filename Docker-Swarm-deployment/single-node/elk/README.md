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
4. Provide the appropriate values for env in `secrets/.logstash.env`

5. Secrets directory after generation of secrets
```sh
secrets/
├── .logstash.env
├── keystores
│   ├── kibana.keystore
│   └── logstash.keystore
├── passwords
│   ├── elasticsearch-cat-password
│   ├── elasticsearch-fs-password
│   ├── elasticsearch-rs-password
│   ├── elasticsearch-su-password
│   ├── es-password.env
│   ├── kibana-admin-password
│   ├── kibana-admin-username
│   ├── kibana-system-password
│   ├── logstash-internal-password
│   ├── logstash-rabbitmq-password
│   ├── logstash-rabbitmq-username
│   ├── logstash-system-password
│   └── snapshot-credentials.env
└── pki
    ├── s3-access-key
    └── s3-secret-key
```

5. Snapshot and Restore 
For AWS-S3, define the `s3-access-key` and `s3-secret-key` in file `secrets/passwords/snapshot-credentials.env` as shown below
```
ELASTICSEARCH_KEYS=s3.client.default.access_key=<s3-access-key>,s3.client.default.secret_key=<s3-secret-key>
```

For Azure-Blob-Storage, define the `storage-account-name` and `storage-access-key` in `secrets/passwords/snapshot-credentials.env` as shown below
```
ELASTICSEARCH_KEYS=azure.client.default.account=<storage_account_name>,azure.client.default.key=<access-key> 
```

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

Define the kibana public URL in [kibana.yaml](kibana/kibana.yaml)

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