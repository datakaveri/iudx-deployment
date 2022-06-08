#!/bin/bash

kubectl create namespace keycloak
kubectl create secret generic keycloak-passwords  --from-file=./secrets/admin-password --fom-file=./secrets/management-password -n keycloak
kubectl create secret generic keycloak-env-secret   --from-file=KEYCLOAK_DATABASE_PASSWORD=./secrets/database-password -n keycloak                  

kubectl create secret generic keycloak-env-secret  --from-file=KEYCLOAK_ADMIN_USER=./secrets/admin-username -n keycloak          

kubectl create secret generic keycloak-env-secret  --from-file=KEYCLOAK_MANAGEMENT_USER=./secrets/management-username -n keycloak
sleep 10
# install keycloak cluster  
helm install -f keycloak-values.yaml -f resource-values.yaml keycloak  --version 4.0.1 $@ bitnami/keycloak -n keycloak

