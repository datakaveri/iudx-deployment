#! /bin/bash

kubectl create namespace dmp-apd
kubectl create configmap dmpapd-env --from-env-file=./secrets/.dmpapd.env -n dmp-apd
kubectl create secret generic dmpapd-config --from-file=./secrets/config.json -n dmp-apd
helm install dmp-apd ../dmp-apd -f values.yaml -f resource-values.yaml $@ -n dmp-apd

