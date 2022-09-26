#!/bin/bash
kubectl create secret generic logstash-keystore --from-file=./secrets/keystores/logstash.keystore  -n elastic
kubectl apply -f logstash/logstash-config.yml -n elastic
helm install -f logstash/ls-values.yml -f logstash/ls-resource-values.yml logstash bitnami/logstash --version 3.8.8 -n elastic $@ 
