# Install ELK
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
    |-- s3-access-key
    `-- s3-secret-key
```
## Build custom Elasticsearch docker image
Custom docker image include S3 snapshot plugin (Recommeded way)[https://github.com/elastic/helm-charts/blob/master/elasticsearch/README.md#how-to-install-plugins]
```sh
docker build -t ghcr.io/datakaveri/elasticsearch:7.12.1 --build-arg es_version=7.12.1 -f elasticsearch/docker/Dockerfile .
```

## Deploy Elasticsearch

es-install.sh script
- generates the keystores from ./generate-keystores.sh
- will generate 3 keystore files in the secrets directory,

```sh
secrets
|-- keystores
|   |-- elasticsearch.keystore
|   |-- kibana.keystore
|   `-- logstash.keystore
```
- generates CA, signed certs from ./elasticsearch/generate-certs.sh
- creates K8s secrets from above credentials
- brings es through helm and elasticsearch/es-values.yml, it can be overriden by passing set helm valuesargs after the scripts. It is illustrated below for the storage class.

```sh
# Deployment of es
./es-install.sh  --set volumeClaimTemplate.storageClassName=<name-of-storage-class>
```
## Deploy Logstash
Once es is deployed and ready. Deploy logstash as follows :
 
```sh
./logstash-install.sh
```

## Deploy Kibana
Once es is deployed and ready/ Deploy kibana as follows: 
```sh
./kibana-install.sh
```
## Tests
Do basic test by creating an index under tests/ directory

