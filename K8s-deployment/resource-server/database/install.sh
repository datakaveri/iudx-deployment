#!/bin/bash
#set -e
./generate-keystore.sh
./elasticsearch/generate-certs.sh
kubectl create namespace elastic
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=secrets/passwords/docker-registry-login \
    --type=kubernetes.io/dockerconfigjson -n elastic
kubectl create secret generic es-keystore --from-file=./secrets/keystores/elasticsearch.keystore  -n elastic
kubectl create secret generic elastic-certificates --from-file=./secrets/pki/elastic-certificates.p12  -n elastic
kubectl create secret generic elastic-credentials --from-file=password=./secrets/passwords/elasticsearch-su-password --from-literal=username=elastic -n elastic
kubectl create secret generic elk-passwords --from-file=./secrets/passwords -n elastic
kubectl create configmap  account-generator --from-file=./elasticsearch/account-generator.sh -n elastic
helm repo add elastic https://helm.elastic.co
# brings up master-coordinator-data-nodes
helm install -f elasticsearch/es-mcd-values.yml  -n elastic elasticsearch-mcd --version 7.12.1 $@  elastic/elasticsearch  &&
helm install -f elasticsearch/es-data-values.yml  -n elastic elasticsearch-data --version 7.12.1 $@  elastic/elasticsearch
kubectl apply -f elasticsearch/account-generator.yml -n elastic 
