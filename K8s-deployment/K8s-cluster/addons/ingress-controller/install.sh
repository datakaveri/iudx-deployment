#!/bin/bash

kubectl create namespace ingress-nginx
kubectl create configmap  error-conf --from-file=./ingress-nginx/conf/error.conf -n ingress-nginx 
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/43174e1970616584f893f66c1fbcac00d110c633/bitnami/ &&  helm repo update
helm install --version=4.0.1 nginx ingress-nginx/ingress-nginx  -f ingress-nginx/nginx-values.yaml -f ingress-nginx/resource-values.yaml -n ingress-nginx && sleep 10 
helm install memcached bitnami/memcached --version=5.14.2 -f memcached/memcached-values.yaml -f memcached/resource-values.yaml -n memcached

