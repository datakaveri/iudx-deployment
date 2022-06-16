#!/bin/bash
kubectl create secret generic kibana-keystore --from-file=./secrets/keystores/kibana.keystore  -n elastic
helm install kibana elastic/kibana -f kibana/kibana-values.yml -f kibana/kibana-resource-values.yaml -n elastic --version=7.12.1