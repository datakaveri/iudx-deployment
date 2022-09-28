#!/bin/bash
#set -e
sudo ./generate-keystore.sh
sudo ./elasticsearch/generate-certs.sh
kubectl create namespace elastic
kubectl create secret generic elastic-certificates --from-file=./secrets/pki/elastic-certificates.p12 -n elastic
kubectl create secret generic elastic-credentials --from-file=elasticsearch-password=./secrets/passwords/elasticsearch-su-password --from-literal=username=elastic -n elastic
kubectl create secret generic elk-passwords --from-file=./secrets/passwords -n elastic
kubectl create configmap  account-generator --from-file=./elasticsearch/account-generator.sh -n elastic

helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
helm install -f elasticsearch/es-values.yml -f elasticsearch/es-resource-values.yml -n elastic elasticsearch --version 17.9.29 $@  bitnami/elasticsearch  &&
kubectl apply -f elasticsearch/account-generator.yml -n elastic
