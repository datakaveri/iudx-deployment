#!/bin/bash
kubectl create secret generic kibana-keystore --from-file=./secrets/keystores/kibana.keystore  -n elastic
helm install kibana bitnami/kibana -f kibana/kibana-values.yml -f kibana/kibana-resource-values.yaml -n elastic --version=10.11.2 $@
