#!/bin/bash

kubectl create namespace redis
kubectl apply -f ../K8s-cluster/sealed-secrets/cluster-wide-sealed-secrets/docker-registry-cred.yaml -n redis
kubectl apply -f sealed-secrets/
sleep 10
# install redis cluster  
helm install -f redis-values.yaml -f resource-values.yaml redis  --version 6.3.3 $@ bitnami/redis-cluster -n redis

sleep 50
#redis-autoscaler
kubectl apply -f autoscale-rbac.yaml
kubectl create configmap redis-autoscale-script   -n redis --from-file=./redis-autoscaler.sh
kubectl apply -f autoscale-cron.yml 
