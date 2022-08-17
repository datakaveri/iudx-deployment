#!/bin/bash
#set -e
sudo ./generate-keystore.sh
sudo ./elasticsearch/generate-certs.sh
kubectl create namespace elastic
kubectl create secret generic es-keystore --from-file=./secrets/keystores/elasticsearch.keystore  -n elastic
kubectl create secret generic elastic-certificates --from-file=./secrets/pki/elastic-certificates.p12  -n elastic
kubectl create secret generic elastic-credentials --from-file=password=./secrets/passwords/elasticsearch-su-password --from-literal=username=elastic -n elastic
kubectl create secret generic elk-passwords --from-file=./secrets/passwords -n elastic
kubectl create configmap  account-generator --from-file=./elasticsearch/account-generator.sh -n elastic
helm repo add elastic https://helm.elastic.co
# brings up master-coordinator-data-nodes
helm install -f elasticsearch/es-mcd-values.yml  -f elasticsearch/es-resource-values.yaml -n elastic elasticsearch-mcd --version 7.12.1 $@  elastic/elasticsearch  &&
helm install -f elasticsearch/es-data-values.yml  -f elasticsearch/es-resource-values.yaml -n elastic elasticsearch-data --version 7.12.1 $@  elastic/elasticsearch
kubectl apply -f elasticsearch/account-generator.yml -n elastic 

## elastic exporter

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install -f elasticsearch/es-exporter-values.yml -f elasticsearch/es-exporter-resource-values.yaml --version 4.7.0 -n elastic es-exporter  prometheus-community/prometheus-elasticsearch-exporter

## elasticSearch data nodes autoscaler

kubectl create configmap es-autoscale-script --from-file=elasticsearch/es-autoscaler.sh -n elastic
kubectl apply -f elasticsearch/autoscale-rbac.yaml -n elastic &&
kubectl apply -f elasticsearch/autoscale-cron.yml -n elastic
