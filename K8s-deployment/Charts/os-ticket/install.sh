#!/bin/bash

kubectl apply -f osticket-secrets.yaml
kubectl apply -f osticket-configmap.yaml
kubectl apply -f osticket-pvc.yaml

kubectl apply -f osticket-config-init-job.yaml

kubectl apply -f osticket-mysql.yaml
kubectl apply -f osticket-web.yaml

kubectl apply -f osticket-ingress.yaml