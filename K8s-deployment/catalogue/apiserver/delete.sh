#!/bin/bash
kubectl delete -f cat-deployment/
kubectl delete secret cat-config-apiserver -n cat-test
kubectl delete secret cat-config-database -n cat-test
kubectl delete secret cat-config-authenticator -n cat-test
kubectl delete secret cat-config-validator -n cat-test
kubectl delete secret  cat-keystore -n cat-test
kubectl delete configmap cat-docs  -n cat-test
kubectl delete configmap cat-env -n cat-test
kubectl delete -f zookeeper.yaml
