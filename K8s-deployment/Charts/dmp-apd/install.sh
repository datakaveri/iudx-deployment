#! /bin/bash

kubectl create namespace dmp-apd
kubectl create configmap dmpApd-env --from-env-file=./secrets/.dmpApd.env -n dmp-apd
kubectl create secret generic dmpApd-config --from-file=./secrets/config.json -n dmp-apd
helm install dmp-apd-server ../dmp-apd -f values.yaml -f resource-values.yaml $@ -n dmp-apd

