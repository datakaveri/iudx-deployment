# Install
## Required secrets
```sh
secrets
|-- passwords
|   |-- elasticsearch-cat-password
|   |-- elasticsearch-fs-password 
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
    |-- s3-access-key
    `-- s3-secret-key
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into root database directory  for demo or local testing purpose only! The kibana is tls secured through centralised nginx.

## Assign node labels

```sh
docker node update --label-add database_node=true <node_name>
```
## Generate tls-cert
```sh
./generate-cert.sh
```
This will generate 2 certificates files in pki directory,
```sh
pki
    ├── elastic-certificates.p12
    ├── elastic-stack-ca.p12
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

Update the proper public-url inside [database-stack.yaml](https://github.com/pranavv0/iudx-deployment/blob/elk-version-update/Docker-Swarm-deployment/single-node/elk/database-stack.yml) Kibana environment Variable

``` SERVER_PUBLICBASEURL=https://<public-url>```

Three ways to deploy, do any one of it
1. Quick deploy
```sh
docker stack deploy -c database-stack.yml database
```
2. Setting resource reservations,limits in 'database-stack.yml' file and then deploying (see [here](example-database-stack.resources.yml) for example configuration of 'database-stack.resources.yml' file ). Its suitable for production environment.

```sh
docker stack deploy -c database-stack.yml -c database-stack.resources.yml database
```
3. You can add more custom stack cofiguration in file 'database-stack.custom.yml' that overrides base 'database-stack.yml' file like ports mapping etc ( see [here](example-database-stack.custom.yml) for example configuration of 'database-stack.custom.yml' file)  and bring up like as follows.
```sh
docker stack deploy -c database-stack.yml  -c database-stack.custom.yml database
```
or
with resource limits, reservations and exposing port number
```sh
docker stack deploy -c database-stack.yml -c database-stack.resources.yml -c database-stack.custom.yml database
```

Bring up the account generator stack(only on clean deployment),
```sh
docker stack deploy -c account-generator.yml tmp 
```

# Monitor logs to ensure creation
```sh
docker service logs tmp_account-generator -f
```

# Remove stack
```sh
docker stack rm tmp 
```


