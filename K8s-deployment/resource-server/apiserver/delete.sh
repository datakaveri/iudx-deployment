#!/bin/bash
kubectl delete -f rs-deployment/
kubectl delete secret rs-config-apiserver -n rs
kubectl delete secret rs-config-databroker -n rs
kubectl delete secret rs-config-latest-database -n rs
kubectl delete secret rs-config-archives-database -n rs
kubectl delete secret rs-config-metering -n rs
kubectl delete secret rs-config-authenticator -n rs
kubectl delete secret  rs-keystore -n rs
kubectl delete configmap rs-env -n rs
