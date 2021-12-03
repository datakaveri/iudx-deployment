#!/bin/bash
kubectl create namespace rs
kubectl apply -f ingress.yaml
kubectl create secret tls rs-tls-secret --key ./secrets/pki/privkey.pem --cert ./secrets/pki/fullchain.pem -n rs
kubectl create configmap rs-env --from-env-file=.rs-api.env -n rs
kubectl create secret generic rs-keystore --from-file=secrets/keystore.jks -n rs
kubectl create secret generic rs-config-apiserver --from-file=secrets/one-verticle-configs/config-apiserver.json -n rs
kubectl create secret generic rs-config-authenticator --from-file=secrets/one-verticle-configs/config-authenticator.json -n rs	
kubectl create secret generic rs-config-archives-database --from-file=secrets/one-verticle-configs/config-archives-database.json -n rs
kubectl create secret generic rs-config-latest-database --from-file=secrets/one-verticle-configs/config-latest-database.json -n rs
kubectl create secret generic rs-config-metering --from-file=secrets/one-verticle-configs/config-metering.json -n rs
kubectl create secret generic rs-config-databroker --from-file=secrets/one-verticle-configs/config-databroker.json -n rs
sleep 10
kubectl apply -f rs-deployment/
