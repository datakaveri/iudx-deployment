#! /bin/bash

kubectl create namespace rs-proxy
kubectl create configmap rs-proxy-env --from-env-file=./secrets/.rs-proxy.env -n rs-proxy
kubectl create secret generic rs-proxy-config --from-file=./secrets/config.json -n rs-proxy
helm install rs-proxy ../rs-proxy -f values.yaml -f resource-values.yaml $@ -n rs-proxy
