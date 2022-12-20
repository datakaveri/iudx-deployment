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
```
# secrets directory after generation of secret files
secrets/
├── passwords/
│   ├── elasticsearch-cat-password
│   ├── elasticsearch-cat-username
│   ├── elasticsearch-fs-password
│   ├── elasticsearch-fs-username
│   ├── elasticsearch-monitor-password
│   ├── elasticsearch-monitor-username
│   ├── elasticsearch-rs-password
│   ├── elasticsearch-rs-username
│   ├── elasticsearch-su-password
│   ├── elasticsearch-su-username
│   ├── kibana-admin-password
│   ├── kibana-admin-username
│   ├── kibana-password
│   ├── kibana-system-username
│   ├── logstash-internal-password
│   ├── logstash-internal-username
│   ├── logstash-rabbitmq-password
│   ├── logstash-rabbitmq-username
│   ├── logstash-system-password
│   ├── logstash-system-username
│   └── s3-credentials
└── pki/
```

### Snapshot and Restore 
For AWS-S3, define the `s3-access-key` and `s3-secret-key` in file `secrets/passwords/snapshot-credentials` and remove remaining params as shown below
```
s3.client.default.access_key=<s3-access-key>,s3.client.default.secret_key=<s3-secret-key>
```

For Azure-Blob-Storage, define the `storage-account-name` and `storage-access-key` in `secrets/passwords/snapshot-credentials` and remove remaining params as shown below
```
azure.client.default.account=<storage_account_name>,azure.client.default.key=<access-key> 
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of requests and limits
- RAM of resuests and limits
- nodeSelector
- Storage class name
- cert-manager issuer and ingress hostname in kibana-resource-values.yaml

in `elasticsearch/es-resource-values.yaml`, `logstash/ls-resource-values.yaml`, and `kibana/kibana-resource-values.yaml` as shown in sample resource-values files present in the [`elasticsearch/`](./elasticsearch/), [`logstash/`](./logstash/), and [`kibana/`](./kibana/) directories respectively.

Define Appropriate nodeSelector value in the [`elasticsearch/autoscale-cron.yml`](./elasticsearch/autoscale-cron.yml)

## Deploy Elasticsearch

es-install.sh script
- generates the keystores from ./generate-keystores.sh
- will generate 2 keystore files in the secrets directory,

```
secrets/
├── keystores
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

