#!/bin/bash

kubectl create ns immudb
kubectl create secret generic hook-secret --from-file=./secrets/passwords -n immudb
kubectl create configmap config-env --from-env-file=./secrets/.config.env -n immudb

helm install immudb ../immudb -f values.yaml -f resource-values.yaml -n immudb
sleep 5
kubectl apply -f immudb-audit.yaml
