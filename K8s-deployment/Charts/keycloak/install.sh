#!/bin/bash

kubectl create namespace keycloak
kubectl create secret generic keycloak-admin-password --from-file=./secrets/admin-password -n keycloak
kubectl create secret generic keycloak-db-password --from-file=./secrets/db-password -n keycloak
sleep 10
# install keycloak cluster 
helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
helm install -f values.yaml -f resource-values.yaml keycloak  --version 15.0.3 $@ bitnami/keycloak -n keycloak
