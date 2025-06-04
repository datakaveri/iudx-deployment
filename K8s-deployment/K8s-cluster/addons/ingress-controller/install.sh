#!/bin/bash

kubectl create namespace ingress-nginx
kubectl create configmap  error-conf --from-file=./ingress-nginx/conf/error.conf -n ingress-nginx 
kubectl create configmap  iudx-cos-root  --from-file=ingress-nginx/iudx-html/ -n ingress-nginx
kubectl create configmap  ugix-cos-root  --from-file=ingress-nginx/ugix-html/ -n ingress-nginx
kubectl create configmap  adex-cos-root  --from-file=ingress-nginx/adex-html/ -n ingress-nginx
helm repo update ingress-nginx bitnami
helm install --version=4.12.2 nginx ingress-nginx/ingress-nginx  -f ingress-nginx/nginx-values.yaml -f ingress-nginx/resource-values.yaml -n ingress-nginx && sleep 10 

