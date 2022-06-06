#!/bin/bash
kubectl create secret generic logstash-keystore --from-file=./secrets/keystores/logstash.keystore  -n elastic
helm repo add elastic https://helm.elastic.co && helm repo update && helm install -f logstash/ls-values.yml  -n elastic logstash elastic/logstash --version 7.12.1 $@ 

