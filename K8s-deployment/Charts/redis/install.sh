#!/bin/bash

kubectl create namespace redis
kubectl create secret generic redis-passwords  --from-file=./secrets/redis-password -n redis  -o yaml 
sleep 10
# install redis cluster  
helm install -f redis-values.yaml -f resource-values.yaml redis  --version 6.3.3 $@ bitnami/redis-cluster -n redis

sleep 50
#redis-autoscaler
kubectl apply -f autoscale-rbac.yaml
kubectl create configmap redis-autoscale-script   -n redis --from-file=./redis-autoscaler.sh
kubectl apply -f autoscale-cron.yaml 
