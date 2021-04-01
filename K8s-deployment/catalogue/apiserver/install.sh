#!/bin/bash
kubectl create namespace cat-test
kubectl create configmap cat-docs  --from-file=docs/openapi.yaml --from-file=docs/apidoc.html --from-file=docs/iudx.png --from-file=docs/cat_overview.png -n cat-test
kubectl create configmap cat-env --from-env-file=.cat-api.env -n cat-test
kubectl create secret generic cat-keystore --from-file=secrets/keystore.jks -n cat-test
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=$HOME/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson -n cat-test
kubectl create secret generic cat-config-apiserver --from-file=secrets/one-verticle-configs/config-apiserver.json -n cat-test
kubectl create secret generic cat-config-authenticator --from-file=secrets/one-verticle-configs/config-authenticator.json -n cat-test
kubectl create secret generic cat-config-validator --from-file=secrets/one-verticle-configs/config-validator.json -n cat-test
kubectl create secret generic cat-config-database --from-file=secrets/one-verticle-configs/config-database.json -n cat-test
kubectl apply -f zookeeper.yaml 
sleep 10
kubectl apply -f cat-deployment/
