#!/bin/bash

kubectl create namespace keycloak
kubectl create secret generic keycloak-passwords  --from-file=./secrets/admin-password --from-file=./secrets/management-password -n keycloak
kubectl create secret generic keycloak-env-secret   --from-file=password=./secrets/password --from-file=KEYCLOAK_ADMIN_USER=./secrets/admin-username --from-file=KEYCLOAK_MANAGEMENT_USER=./secrets/management-username -n keycloak
sleep 10
# install keycloak cluster 
helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
helm install -f values.yaml -f resource-values.yaml keycloak  --version 9.3.1 $@ bitnami/keycloak -n keycloak

