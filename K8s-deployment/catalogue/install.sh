#!/bin/bash
kubectl create namespace cat
kubectl create secret tls catalogue-tls-secret --key ./secrets/pki/privkey.pem --cert ./secrets/pki/fullchain.pem -n cat

kubectl create configmap cat-env --from-env-file=.cat-api.env -n cat
kubectl create secret generic cat-keystore --from-file=secrets/keystore.jks -n cat
kubectl apply -f ../../K8s-cluster/addons/sealed-secrets/cluster-wide-sealed-secrets/docker-registry-cred.yaml -n cat 
kubectl create secret generic cat-config-apiserver --from-file=secrets/one-verticle-configs/config-apiserver.json -n cat
kubectl create secret generic cat-config-authenticator --from-file=secrets/one-verticle-configs/config-authenticator.json -n cat
kubectl create secret generic cat-config-validator --from-file=secrets/one-verticle-configs/config-validator.json -n cat
kubectl create secret generic cat-config-database --from-file=secrets/one-verticle-configs/config-database.json -n cat
kubectl create secret generic cat-config-auditing --from-file=secrets/one-verticle-configs/config-auditing.json -n cat

sleep 10

helm install cat-helm cat-helm-mini/
