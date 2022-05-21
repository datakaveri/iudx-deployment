#!/bin/bash

kubectl create namespace postgres
kubectl create secret generic psql-passwords  --from-file=./secrets/postgresql-password --from-file=./secrets/repmgr-password --from-file=./secrets/postgres-auth-password --from-file=./secrets/postgres-rs-password --from-file=./secrets/postgres-keycloak-password -n postgres  
kubectl create secret generic pgpool-auth  --from-file=./secrets/usernames --from-file=./secrets/passwords  -n postgres

kubectl create configmap init-scripts --from-file=./init-scripts/ -n postgres
sleep 10
# install postgres asynchronous cluster  
helm install -f psql-async-values.yaml -f resource-values.yaml psql --version 7.7.3 $@ bitnami/postgresql-ha -n postgres
sleep 100

# helm upgrade to postgres quorum synchronous replication cluster
POSTGRES_PASSWORD=$(kubectl get secret --namespace  postgres psql-passwords -o jsonpath="{.data.postgresql-password}" | base64 --decode)
 REPMGR_PASSWORD=$(kubectl get secret --namespace postgres psql-passwords -o jsonpath="{.data.repmgr-password}" | base64 --decode)
 POOL_ADMIN_PASSWORD=$(kubectl get secret --namespace postgres psql-postgresql-ha-pgpool -o jsonpath="{.data.admin-password}" | base64 --decode)
helm upgrade -f psql-async-values.yaml -f psql-sync-values.yaml -f resource-values.yaml -n  postgres psql  bitnami/postgresql-ha --version=7.7.3 $@ --set postgresql.password=$POSTGRES_PASSWORD  --set postgresql.repmgrPassword=$REPMGR_PASSWORD --set pgpool.adminPassword=$POOL_ADMIN_PASSWORD


