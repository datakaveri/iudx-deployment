#! /bin/bash

kubectl create namespace uac-cat
kubectl create configmap cat-env --from-env-file=./secrets/.cat.env -n uac-cat
kubectl create secret generic cat-config --from-file=./secrets/config.json -n uac-cat
helm install uac-catalogue-server ../uac-catalogue -f values.yaml -f resource-values.yaml $@ -n uac-cat
