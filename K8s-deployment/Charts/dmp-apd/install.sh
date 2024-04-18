#! /bin/bash

kubectl create namespace dmpapd
kubectl create configmap dmpapd-env --from-env-file=./secrets/.dmpapd.env -n dmpapd
kubectl create secret generic dmpapd-config --from-file=./secrets/config.json -n dmpapd
helm install dmpapd-server ../dmp-apd -f values.yaml -f resource-values.yaml $@ -n dmpapd

