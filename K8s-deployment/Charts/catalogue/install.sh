#! /bin/bash

kubectl create namespace cat
kubectl create configmap cat-env --from-env-file=./secrets/.cat.env -n cat
kubectl create secret generic cat-config --from-file=./secrets/config.json -n cat
helm install catalogue-server ../catalogue -f values.yaml -f resource-values.yaml $@ -n cat
