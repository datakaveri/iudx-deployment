#! /bin/bash

kubectl create namespace adex-rs-proxy
kubectl create configmap rs-proxy-env --from-env-file=./secrets/.rs-proxy.env -n adex-rs-proxy
kubectl create secret generic rs-proxy-cert --from-file=./secrets/Test-Class2DocumentSigner2014.pfx -n adex-rs-proxy
kubectl create secret generic rs-proxy-config --from-file=./secrets/config.json -n adex-rs-proxy
helm install rs-proxy ../rs-proxy -f values.yaml -f resource-values.yaml $@ -n adex-rs-proxy
