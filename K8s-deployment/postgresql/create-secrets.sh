#!/bin/bash

set -e 

create_secret() {

kubectl create secret generic $1  --dry-run=client --from-file=./secrets/$2 -n postgres  -o yaml | kubeseal --cert ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem  --format yaml > sealed-secrets/$1.yaml
}

merge_secret() {

 kubectl create secret generic $1 --dry-run=client --from-file=./secrets/$2 -n postgres -o yaml | kubeseal --cert  ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem --format yaml  --merge-into sealed-secrets/$1.yaml

}

echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/postgresql-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/repmgr-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/postgres-auth-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/postgres-rs-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/postgres-keycloak-password

create_secret psql-passwords postgresql-password
merge_secret psql-passwords repmgr-password
merge_secret psql-passwords postgres-rs-password
merge_secret psql-passwords postgres-auth-password
merge_secret psql-passwords postgres-keycloak-password

echo -n "postgres;iudx_rs_user;iudx_auth_user;iudx_keycloak_user" > secrets/usernames
echo -n "$(cat secrets/postgresql-password);$(cat secrets/postgres-rs-password);$(cat secrets/postgres-auth-password);$(cat secrets/postgres-keycloak-password)" > secrets/passwords

create_secret pgpool-auth usernames
merge_secret pgpool-auth passwords

kubectl create secret generic backup-s3-secret  --dry-run=client --from-file=S3_ACCESS_ID=./secrets/s3-access-id -n postgres  -o yaml | kubeseal --cert ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem  --format yaml > sealed-secrets/backup-s3-secret.yaml

kubectl create secret generic backup-s3-secret  --dry-run=client --from-file=S3_ACCESS_KEY=./secrets/s3-access-key -n postgres  -o yaml | kubeseal --cert ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem  --format yaml --merge-into  sealed-secrets/backup-s3-secret.yaml

kubectl create secret generic backup-s3-secret  --dry-run=client --from-file=S3_BUCKET_NAME=./secrets/s3-bucket-name -n postgres  -o yaml | kubeseal --cert ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem  --format yaml --merge-into sealed-secrets/backup-s3-secret.yaml
