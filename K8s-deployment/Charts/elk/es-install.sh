#!/bin/bash
#set -e
sudo ./generate-keystore.sh
sudo ./elasticsearch/generate-certs.sh
kubectl create namespace elastic
kubectl create secret generic elastic-certificates --from-file=./secrets/pki/elastic-certificates.p12  -n elastic
kubectl create secret generic elastic-credentials --from-file=elasticsearch-password=./secrets/passwords/elasticsearch-su-password --from-literal=username=elastic -n elastic
kubectl create secret generic elk-passwords --from-file=./secrets/passwords -n elastic
kubectl create configmap  account-generator-config --from-file=./elasticsearch/account-generator-config.json -n elastic
kubectl create configmap elasticsearch-data-node-config --from-file=./elasticsearch/data-conf/my_elasticsearch.yml -n elastic
kubectl create configmap elasticsearch-master-node-config --from-file=./elasticsearch/master-conf/my_elasticsearch.yml -n elastic
kubectl create configmap elastic-java-net-options --from-file=./elasticsearch/java-net.options -n elastic

# brings up Elastic mcd and data-only nodes
helm repo update bitnami
helm install -f elasticsearch/es-values.yml -f elasticsearch/es-resource-values.yaml -n elastic elasticsearch --version 19.19.2 $@  bitnami/elasticsearch  &&
kubectl apply -f elasticsearch/account-generator.yml -n elastic

## elasticSearch data nodes autoscaler
kubectl create configmap es-autoscale-script --from-file=elasticsearch/es-autoscaler.sh -n elastic
kubectl apply -f elasticsearch/autoscale-rbac.yaml -n elastic &&
kubectl apply -f elasticsearch/autoscale-cron.yml -n elastic
