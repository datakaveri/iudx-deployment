#! /bin/bash

kubectl create namespace lip
kubectl create configmap lip-env --from-env-file=./secrets/.lip.env -n lip
kubectl create secret generic attribute-mapping --from-file=./secrets/attribute-mapping.json -n lip
kubectl create secret generic lip-config --from-file=./secrets/config.json -n lip
helm install latest-ingestion-pipeline ../latest-ingestion-pipeline -f values.yaml -f resource-values.yaml $@ -n lip