# Install
## Required secrets
```sh
secrets
|-- passwords
|   |-- elasticsearch-cat-password
|   |-- elasticsearch-rs-password
|   |-- elasticsearch-su-password
|   |-- kibana-admin-password
|   |-- kibana-admin-username
|   |-- kibana-system-password
|   |-- logstash-internal-password
|   |-- logstash-rabbitmq-password
|   |-- logstash-rabbitmq-username
|   `-- logstash-system-password
`-- pki
    |-- kibana-tls-cert
    |-- kibana-tls-key
    |-- s3-access-key
    `-- s3-secret-key
```

## Generate keystores
Running,
```sh
./generate-keystore.sh
```
will generate 3 keystore files in the secrets directory,
```sh
secrets
|-- keystores
|   |-- elasticsearch.keystore
|   |-- kibana.keystore
|   `-- logstash.keystore
```

## Deploy

Bring up the database stack,
```sh
docker stack deploy -c database-stack.yml database 
```
Bring up the account generator stack(only on clean deployment),
```sh
docker stack deploy -c account-generator.yml tmp 

# Monitor logs to ensure creation
docker service logs tmp_account-generator -f

# Remove stack
docker stack rm tmp 
```