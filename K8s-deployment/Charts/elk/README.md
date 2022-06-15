# Install ELK

## Generating secrets

Make a copy of sample secrets directory:

```sh
cp -r example-secrets/secrets .
```
To generate the passwords:

```sh
./create-secrets.sh
```
Appropriately define the `s3-access-key` and `s3-secret-key` in the `secrets/pki` directory
```
# secrets directory after generation of secret files
secrets/
├── passwords/
│   ├── elasticsearch-cat-password
│   ├── elasticsearch-cat-username
│   ├── elasticsearch-rs-password
│   ├── elasticsearch-rs-username
│   ├── elasticsearch-su-password
│   ├── elasticsearch-su-username
│   ├── kibana-admin-password
│   ├── kibana-admin-username
│   ├── kibana-system-password
│   ├── kibana-system-username
│   ├── logstash-internal-password
│   ├── logstash-internal-username
│   ├── logstash-rabbitmq-password
│   ├── logstash-rabbitmq-username
│   ├── logstash-system-password
│   └── logstash-system-username
└── pki/
    ├── s3-access-key
    └── s3-secret-key
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of requests and limits
- RAM of resuests and limits
- nodeSelector
- Storage class name

in `es-resource-values.yaml`, `ls-resource-values.yaml`, and `kibana-resource-values.yaml` as shown in sample resource-values files present in the [`elasticsearch/`](./elasticsearch/), [`logstash/`](./logstash/), and [`kibana/`](./kibana/) directories respectively.

## Build custom Elasticsearch docker image
Custom docker image include S3 snapshot plugin (Recommeded way)[https://github.com/elastic/helm-charts/blob/master/elasticsearch/README.md#how-to-install-plugins]
```sh
docker build -t ghcr.io/datakaveri/elasticsearch:7.12.1 --build-arg es_version=7.12.1 -f elasticsearch/docker/Dockerfile .
```

## Deploy Elasticsearch

es-install.sh script
- generates the keystores from ./generate-keystores.sh
- will generate 3 keystore files in the secrets directory,

```
secrets/
├── keystores
│   ├── elasticsearch.keystore
│   ├── kibana.keystore
│   └── logstash.keystore

```
- generates CA, signed certs from ./elasticsearch/generate-certs.sh
- creates K8s secrets from above credentials
- deploys es through helm 
- deploys es-autoscaler-cron job in K8s which autoscales the es-data-nodes

Deploy es as follows:

```sh
./es-install.sh
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

