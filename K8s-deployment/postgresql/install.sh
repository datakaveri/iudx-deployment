#!/bin/bash

kubectl create namespace postgres
kubectl apply -f ../K8s-cluster/sealed-secrets/cluster-wide-sealed-secrets/docker-registry-cred.yaml -n postgres
kubectl apply -f sealed-secrets/
kubectl create configmap backup-s3-cfg --from-file=s3cfg=conf/backup-s3-cfg -n postgres
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

sleep 100

# install pg_dumpall K8s cronjob
kubectl create configmap pg-backup-script --from-file=backup-script.sh -n postgres 
kubectl apply -f pg-backup-cron.yaml -n postgres 
