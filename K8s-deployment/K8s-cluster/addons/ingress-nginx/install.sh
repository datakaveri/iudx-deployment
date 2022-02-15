#!/bin/bash

kubectl create namespace ingress-nginx
kubectl create configmap  error-conf --from-file=./conf/error.conf -n ingress-nginx 
helm install --version=4.0.1 nginx ingress-nginx/ingress-nginx  -f nginx-values.yaml -f nginx-resource-values.yaml -n ingress-nginx
helm install memcached bitnami/memcached --version=5.14.2 -f memcached-values.yaml -f memcached-resource-values.yaml -n memcached

