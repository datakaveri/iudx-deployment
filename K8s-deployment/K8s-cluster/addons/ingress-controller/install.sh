#!/bin/bash

kubectl create namespace ingress-nginx && kubectl create namespace memcached
kubectl create configmap  error-conf --from-file=./ingress-nginx/conf/error.conf -n ingress-nginx 
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami &&  helm repo update
helm install --version=4.2.5 nginx ingress-nginx/ingress-nginx  -f ingress-nginx/nginx-values.yaml -f ingress-nginx/resource-values.yaml -n ingress-nginx && sleep 10 
helm install memcached bitnami/memcached --version=6.2.4 -f memcached/memcached-values.yaml -f memcached/resource-values.yaml -n memcached

