#! /bin/bash

kubectl create namespace aaa
kubectl create configmap aaa-env --from-env-file=./secrets/.aaa.env -n aaa
kubectl create secret generic aaa-config --from-file=./secrets/config.json -n aaa
kubectl create secret generic aaa-keystore --from-file=./secrets/keystore.jks -n aaa
helm install auth-server ../auth-server -f values.yaml -f resource-values.yaml $@ -n aaa