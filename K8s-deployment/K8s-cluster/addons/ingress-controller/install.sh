#!/bin/bash

kubectl create namespace ingress-nginx && kubectl create namespace memcached
kubectl create configmap  error-conf --from-file=./ingress-nginx/conf/error.conf -n ingress-nginx 
kubectl create configmap  iudx-cos-root  --from-file=ingress-nginx/iudx-html/ -n ingress-nginx
kubectl create configmap  ugix-cos-root  --from-file=ingress-nginx/ugix-html/ -n ingress-nginx
kubectl create configmap  adex-cos-root  --from-file=ingress-nginx/adex-html/ -n ingress-nginx
helm repo update ingress-nginx bitnami
helm install --version=4.9.0 nginx ingress-nginx/ingress-nginx  -f ingress-nginx/nginx-values.yaml -f ingress-nginx/resource-values.yaml -n ingress-nginx && sleep 10 
helm install memcached bitnami/memcached --version=6.7.2 -f memcached/memcached-values.yaml -f memcached/resource-values.yaml -n memcached

