#! /bin/bash

kubectl create namespace consent
kubectl create configmap cv-env --from-env-file=./secrets/.cv.env -n consent
kubectl create secret generic cv-config --from-file=./secrets/config.json -n consent
kubectl create secret generic cv-keystore --from-file=./secrets/keystore.jks -n consent
helm install consent-validator ../consent-validator -f values.yaml -f resource-values.yaml  $@ -n consent
