#!/bin/bash
kubectl create secret generic logstash-keystore --from-file=./secrets/keystores/logstash.keystore  -n elastic
kubectl apply -f logstash/logstash-config.yaml -n elastic
helm install -f logstash/ls-values.yml -f logstash/ls-resource-values.yaml -n elastic logstash bitnami/logstash --version 5.1.1 $@ 
