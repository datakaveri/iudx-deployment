# Installation
This installs a postgres HA synchronous replication cluster with pgpool as proxy pod and repmgr for failover and backup using velero.
The helm chart is based on bitnami : https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha 

## Create secrets 
1. Generate required secrets  using follwing script:
```
# command
./create_secrets.sh

# secrets directory after generation of secrets
secrets/
├── passwords (contains all passwords concatenated using ':')
├── postgres-auth-password (used by aaa)
├── postgres-keycloak-password (used by keycloak)
├── postgres-rs-password (used by rs)
├── postgresql-password (super user password)
├── repmgr-password (used repmgr for replication)
└── usernames
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of postgres and pgpool
- RAM of postgres and pgpool
- node-selector for postgres and pgpool, to schedule the pods on particular type of node
- Disk storage size and storage class
- connections related settings 
as shown in example-aws-resource-values.yaml

## Deploy

```
./install.sh
```

Following script will create :
1. create a namespace postgres
2. create corresponding K8s secrets from  secrets directory
3. create required configmaps
4. Initialize asynchronous postgres replication cluster with initdb scripts 
5. Upgrade the cluster with synchrounous replication

## RS, auth scehma creation
The rs and auth schema created using flyway using following steps:
1. Port forward the pgpool (postgres proxy) on one terminal
```kubectl port-forward -n postgres svc/psql-postgresql-ha-pgpool 5432
```
2. In another terminal, git clone each repo and do following
  2.1 adjust flyway config 
  2.2 Do flyway migrate
  Refer here for more info: https://github.com/datakaveri/iudx-aaa-server#flyway-database-setup