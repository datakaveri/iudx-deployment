#!/bin/bash
kubectl create namespace aaa
kubectl apply -f ingress.yaml
kubectl create secret tls aaa-tls-secret --key ./secrets/pki/privkey.pem --cert ./secrets/pki/fullchain.pem -n aaa
kubectl create configmap aaa-env --from-env-file=.aaa.env -n aaa
kubectl create secret generic aaa-keystore --from-file=secrets/keystore.jks -n aaa
kubectl create secret generic aaa-config --from-file=secrets/all-verticles-configs/config.json -n aaa
sleep 10
kubectl apply -f aaa-deployment/
