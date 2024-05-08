#!/bin/bash

kubectl create namespace postgres
kubectl create secret generic psql-passwords --from-file=password=./secrets/passwords/postgresql-password --from-file=./secrets/passwords/postgresql-password --from-file=./secrets/passwords/repmgr-password --from-file=./secrets/passwords/postgres-auth-password --from-file=./secrets/passwords/postgres-rs-password --from-file=./secrets/passwords/postgres-keycloak-password -n postgres  
kubectl create secret generic pgpool-auth  --from-file=./secrets/passwords/usernames --from-file=./secrets/passwords/passwords  -n postgres

#kubectl create configmap init-scripts --from-file=./init-scripts/ -n postgres
kubectl create configmap db-user-creation-config --from-file=./init-scripts/db-user-creation-config.json -n postgres
sleep 10
# install postgres asynchronous cluster  
helm repo update bitnami
helm install -f psql-async-values.yaml -f resource-values.yaml psql --version 13.0.1 $@ bitnami/postgresql-ha -n postgres

# helm delete and install  to postgres quorum synchronous replication cluster
POSTGRES_PASSWORD=$(kubectl get secret --namespace  postgres psql-passwords -o jsonpath="{.data.postgresql-password}" | base64 --decode)
REPMGR_PASSWORD=$(kubectl get secret --namespace postgres psql-passwords -o jsonpath="{.data.repmgr-password}" | base64 --decode)
POOL_ADMIN_PASSWORD=$(kubectl get secret --namespace postgres psql-postgresql-ha-pgpool -o jsonpath="{.data.admin-password}" | base64 --decode)
sleep 150

helm delete -n postgres  psql && sleep 50

helm install -f psql-async-values.yaml -f psql-sync-values.yaml -f resource-values.yaml -n  postgres psql  bitnami/postgresql-ha --version=13.0.1 $@ --set postgresql.password=$POSTGRES_PASSWORD  --set postgresql.repmgrPassword=$REPMGR_PASSWORD --set pgpool.adminPassword=$POOL_ADMIN_PASSWORD
