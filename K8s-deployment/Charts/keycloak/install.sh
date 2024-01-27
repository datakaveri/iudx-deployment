#!/bin/bash

kubectl create namespace keycloak
kubectl create secret generic keycloak-admin-password --from-file=./secrets/admin-password -n keycloak
kubectl create secret generic keycloak-db-password --from-file=./secrets/db-password -n keycloak
sleep 10
# install keycloak cluster 
helm repo update bitnami
helm install -f values.yaml -f resources.yaml keycloak  --version 16.1.1 $@ bitnami/keycloak -n keycloak
