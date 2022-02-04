#!/bin/bash
kubectl create namespace rs-test
kubectl create configmap rs-docs  --from-file=docs/openapi.yaml --from-file=docs/apidoc.html --from-file=docs/iudx.png --from-file=docs/rs_overview.png -n rs-test
kubectl create configmap rs-env --from-env-file=.rs-api.env -n rs-test
kubectl create secret generic rs-keystore --from-file=secrets/keystore.jks -n rs-test
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=$HOME/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson -n rs-test
kubectl create secret generic rs-config-apiserver --from-file=secrets/one-verticle-configs/config-apiserver.json -n rs-test
kubectl create secret generic rs-config-authenticator --from-file=secrets/one-verticle-configs/config-authenticator.json -n rs-test
kubectl create secret generic rs-config-callback --from-file=secrets/one-verticle-configs/config-callback.json -n rs-test
kubectl create secret generic rs-config-database --from-file=secrets/one-verticle-configs/config-database.json -n rs-test
kubectl create secret generic rs-config-databroker --from-file=secrets/one-verticle-configs/config-databroker.json -n rs-test
kubectl apply -f zookeeper.yaml 
sleep 10
kubectl apply -f rs-deployment/
