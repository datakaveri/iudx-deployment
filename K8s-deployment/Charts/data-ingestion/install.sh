#!/bin/bash

kubectl create namespace di
kubectl create secret generic di-config --from-file=configs/config.json -n di
helm install di ../data-ingestion -f values.yaml -f resource-values.yaml -n di