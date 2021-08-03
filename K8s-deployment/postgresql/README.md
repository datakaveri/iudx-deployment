# Installation
This installs a postgres HA synchronous replication cluster with pgpool as proxy pod and repmgr for failover and backup using pgdumpall to s3 bucket.
The helm chart is based on bitnami : https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha 

## Create S3 bucket and credentials

Create S3 bucket and place the aws s3 access credentials as follows:

```
secrets/
├── s3-access-id
├── s3-access-key
└── s3-bucket-name
```
## Create Sealed secrets
0. Generate sealed secret for docker registry login if not generated, see [here](../K8s-cluster/sealed-secrets/README.md)
1. Generate required secrets and create sealed secrets using follwing command:
```
# command
./create_secrets.sh

# secrets directory after generation of secrets
secrets/
├── passwords
├── postgres-auth-password
├── postgres-keycloak-password
├── postgres-rs-password
├── postgresql-password
├── repmgr-password
├── s3-access-id
├── s3-access-key
├── s3-bucket-name
└── usernames

# sealed-secrets
sealed-secrets/
├── backup-s3-secret.yaml
├── pgpool-auth.yaml
└── psql-passwords.yaml
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of postgres and pgpool
- RAM of postgres and pgpool
- Disk storage size and storage class
- connections related settings 
in resource-values.yaml as shown below:

```
postgresql:
  resources:
    limits:
       cpu: 1000m
       memory: 2Gi
    requests:
       cpu: 1000m
       memory: 2Gi
  maxConnections: 130

pgpool:
  resources:
    limits:
       cpu: 250m
       memory: 512Mi
    requests:
       cpu: 250m
       memory: 512Mi
  ## The number of preforked Pgpool-II server processes. It is also the concurrent
  ## connections limit to Pgpool-II from clients. Must be a positive integer. (PGPOOL\_NUM\_INIT\_CHILDREN)
  ## ref: https://github.com/bitnami/bitnami-docker-pgpool#configuration
  ##
  numInitChildren: 32

  ## The maximum number of cached connections in each child process (PGPOOL\_MAX\_POOL)
  ## ref: https://github.com/bitnami/bitnami-docker-pgpool#configuration
  ##
  maxPool: 2

persistence:
  accessModes:
    - ReadWriteOnce
  size: 8Gi
  annotations:
  selector:
  storageClass: "ebs-storage-class"

```

## Deploy

```
./install.sh
```

Following script will create :
1. create a namespace postgres
2. create corresponding K8s secrets from sealed secrets
3. create required configmaps
4. Initialize asynchronous postgres replication cluster with initdb scripts 
5. Upgrade the cluster with synchrounous replication
6. Deploy postgres backup cron job
