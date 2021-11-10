#!/bin/bash
kubectl delete -f cat-deployment/
kubectl delete secret cat-config-apiserver -n cat
kubectl delete secret cat-config-database -n cat
kubectl delete secret cat-config-authenticator -n cat
kubectl delete secret cat-config-validator -n cat
kubectl delete secret cat-config-auditing -n cat
kubectl delete secret  cat-keystore -n cat
kubectl delete configmap cat-env -n cat
