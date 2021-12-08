#!/bin/bash
kubectl create namespace lip
kubectl create secret generic attribute-mapping  --from-file=secrets/attribute-mapping.json  -n lip
kubectl create configmap lip-env --from-env-file=.lip.env -n lip
kubectl create secret generic lip-config-processor --from-file=secrets/one-verticle-configs/config-processor.json -n lip
kubectl create secret generic lip-config-rabbitmq --from-file=secrets/one-verticle-configs/config-rabbitmq.json -n lip
kubectl create secret generic lip-config-redis --from-file=secrets/one-verticle-configs/config-redis.json -n lip
sleep 10
kubectl apply -f lip-deployment/
