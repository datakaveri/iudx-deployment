#!/bin/bash

kubectl create namespace di
kubectl create configmap di-env --from-env-file=./secrets/.di.env -n di
kubectl create secret generic di-config --from-file=configs/config.json -n di
helm install data-ingestion ../data-ingestion -f values.yaml -f resource-values.yaml $@ -n di