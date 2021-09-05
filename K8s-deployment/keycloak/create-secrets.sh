#!/bin/bash

set -e 

create_secret() {

kubectl create secret generic $1  --dry-run=client --from-file=./secrets/$2 -n keycloak  -o yaml | kubeseal --cert ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem  --format yaml > sealed-secrets/$1.yaml
}

merge_secret() {

 kubectl create secret generic $1 --dry-run=client --from-file=./secrets/$2 -n keycloak -o yaml | kubeseal --cert  ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem --format yaml  --merge-into sealed-secrets/$1.yaml

}

echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/admin-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/management-password
cp ../postgresql/secrets/postgres-keycloak-password   secrets/database-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16) > secrets/admin-username
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16) > secrets/management-username

create_secret keycloak-passwords admin-password
merge_secret keycloak-passwords management-password

kubectl create secret generic keycloak-env-secret  --dry-run=client --from-file=KEYCLOAK_DATABASE_PASSWORD=./secrets/database-password -n keycloak  -o yaml | kubeseal --cert ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem  --format yaml > sealed-secrets/keycloak-env-secret.yaml

kubectl create secret generic keycloak-env-secret --dry-run=client --from-file=KEYCLOAK_ADMIN_USER=./secrets/admin-username -n keycloak -o yaml | kubeseal --cert  ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem --format yaml  --merge-into sealed-secrets/keycloak-env-secret.yaml

kubectl create secret generic keycloak-env-secret --dry-run=client --from-file=KEYCLOAK_MANAGEMENT_USER=./secrets/management-username -n keycloak -o yaml | kubeseal --cert  ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem --format yaml  --merge-into sealed-secrets/keycloak-env-secret.yaml

