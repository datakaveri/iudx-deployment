#!/bin/bash
kubectl create namespace fs
kubectl apply -f ingress.yaml
kubectl create secret tls fs-tls-secret --key ./secrets/pki/privkey.pem --cert ./secrets/pki/fullchain.pem -n fs
kubectl create configmap fs-env --from-env-file=.file-server.env -n fs
kubectl create secret generic fs-keystore --from-file=secrets/keystore-rs.jks --from-file=secrets/keystore-file.jks  -n fs
kubectl create secret generic fs-config-apiserver --from-file=secrets/one-verticle-configs/config-apiserver.json -n fs
kubectl create secret generic fs-config-authenticator --from-file=secrets/one-verticle-configs/config-authenticator.json -n fs
kubectl create secret generic fs-config-database --from-file=secrets/one-verticle-configs/config-database.json -n fs
sleep 10
kubectl apply -f fs-deployment/
