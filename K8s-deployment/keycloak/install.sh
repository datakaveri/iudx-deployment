#!/bin/bash

kubectl create namespace keycloak
kubectl apply -f ../K8s-cluster/sealed-secrets/cluster-wide-sealed-secrets/docker-registry-cred.yaml -n keycloak
kubectl apply -f sealed-secrets/
sleep 10
# install keycloak cluster  
helm install -f keycloak-values.yaml -f resource-values.yaml keycloak  $@ bitnami/keycloak -n keycloak

