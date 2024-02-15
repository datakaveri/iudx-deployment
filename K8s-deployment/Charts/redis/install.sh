#!/bin/bash

kubectl create namespace redis
kubectl create secret generic redis-passwords --from-file=./secrets/redis-password -n redis
sleep 10
# install redis cluster  
helm repo update bitnami
helm install -f values.yaml -f resource-values.yaml redis  --version 9.1.5 $@ bitnami/redis-cluster -n redis

sleep 50
#redis-autoscaler
kubectl apply -f autoscale-rbac.yaml
kubectl create configmap redis-autoscale-script --from-file=./redis-autoscaler.sh -n redis
kubectl apply -f autoscale-cron.yaml
