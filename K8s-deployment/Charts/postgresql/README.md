# Installation
This installs a postgres HA synchronous replication cluster with pgpool as proxy pod and repmgr for failover and backup using velero.
The helm chart is based on bitnami : https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha 

## Generate secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/secrets .
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

## Postgres Users creation
1. Configure `init-script/db-user-creation-config.json` if any changes required
2. Bring up the db generator stack(only on clean deployment),
```sh
kubectl apply -f db-user-creation-job.yaml
```

## RS, auth scehma creation
The rs and auth schema created using flyway using following steps:
1. Port forward the pgpool (postgres proxy) on one terminal
```kubectl port-forward -n postgres svc/psql-postgresql-ha-pgpool 5432
```
2. In another terminal, ``git clone  https://github.com/datakaveri/iudx-aaa-server.git && cd iudx-aaa-server`` repo and do following
  2.1 flyway.conf must be updated with the required data. which will be as follows
  ```
   flyway.url=jdbc:postgresql://127.0.0.1:5432/postgres
   flyway.user=postgres 
   flyway.password=<value in secrets/passwords/postgresql-password>  
   flyway.schemas=aaa 
   flyway.placeholders.authUser=iudx_auth_user 
  ```
  2.2 After this, the info command can be run to test the config. Then, the migrate command can be run to set up the database. At the /iudx-aaa-server directory, run

  ```
  mvn flyway:info -Dflyway.configFiles=flyway.conf
  mvn flyway:migrate -Dflyway.configFiles=flyway.conf
  ```
 Refer here for more info: https://github.com/datakaveri/iudx-aaa-server#flyway-database-setup
3. Similarly do for resource server,  ``git clone https://github.com/datakaveri/iudx-resource-server.git && cd iudx-resource-server``
  3.1 flyway.conf must be updated with the required data. which will be as follows
  ```
  flyway.url=jdbc:postgresql://127.0.0.1:5432/iudx_rs
  flyway.user=postgres
  flyway.password=<value in secrets/passwords/postgresql-password>
  flyway.schemas=public
  flyway.placeholders.rsUser=iudx_rs_user
  flyway.cleanDisabled=true
  # use TRUE only for first time migration of existing DB, else use FALSE.
  flyway.baselineOnMigrate = false
  ```
  2.2 After this, the info command can be run to test the config. Then, the migrate command can be run to set up the database. At the /iudx-resource-server directory, run
  ```
  mvn flyway:info -Dflyway.configFiles=flyway.conf
  mvn flyway:migrate -Dflyway.configFiles=flyway.conf
  ```
# NOTE

1. To do upgrades (image, configs, secrets etc) on potgres cluster, do not use ``helm upgrade``, instead use delete and install helm chart. This is because helm upgrade to psql may cause inconsistent/partitioned cluster formation - one partion of one master and one slave and another of just one master. The code snippet to do helm delete and install is as follows:

```
POSTGRES_PASSWORD=$(kubectl get secret --namespace  postgres psql-passwords -o jsonpath="{.data.postgresql-password}" | base64 --decode)
REPMGR_PASSWORD=$(kubectl get secret --namespace postgres psql-passwords -o jsonpath="{.data.repmgr-password}" | base64 --decode)
POOL_ADMIN_PASSWORD=$(kubectl get secret --namespace postgres psql-postgresql-ha-pgpool -o jsonpath="{.data.admin-password}" | base64 --decode)
sleep 150

helm delete -n postgres  psql && sleep 50

helm install -f psql-async-values.yaml -f psql-sync-values.yaml -f resource-values.yaml -n  postgres psql  bitnami/postgresql-ha --version=9.3.2 $@ --set postgresql.password=$POSTGRES_PASSWORD  --set postgresql.repmgrPassword=$REPMGR_PASSWORD --set pgpool.adminPassword=$POOL_ADMIN_PASSWORD
                                
```
