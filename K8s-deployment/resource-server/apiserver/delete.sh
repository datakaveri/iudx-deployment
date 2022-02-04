#!/bin/bash
kubectl delete -f rs-deployment/
kubectl delete secret rs-config-apiserver -n rs-test
kubectl delete secret rs-config-databroker -n rs-test
kubectl delete secret rs-config-database -n rs-test
kubectl delete secret rs-config-callback -n rs-test
kubectl delete secret rs-config-authenticator -n rs-test
kubectl delete secret  rs-keystore -n rs-test
kubectl delete configmap rs-docs  -n rs-test
kubectl delete configmap rs-env -n rs-test
kubectl delete -f zookeeper.yaml