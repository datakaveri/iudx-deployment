# Installation
This installs a postgres HA synchronous replication cluster with pgpool as proxy pod and repmgr for failover and backup using velero.
The helm chart is based on bitnami : https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha 

## Generate secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
$ cp -r example-secrets/secrets .
```
Generate required secrets  using following script:
```sh
./create-secrets.sh
```
```
# secrets directory after generation of secrets
secrets/
└── passwords
    ├── passwords (contains all passwords concatenated using ':')
    ├── postgres-auth-password (used by aaa)
    ├── postgres-keycloak-password (used by keycloak)
    ├── postgresql-password (super user password )
    ├── postgres-rs-password (used by rs)
    ├── repmgr-password (used by rempgr for replication)
    └── usernames (contains all usernames concatenated using ';')
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of postgres and pgpool
- RAM of postgres and pgpool
- node-selector for postgres and pgpool, to schedule the pods on particular type of node
- Disk storage size and storage class
- connections related settings 

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

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
