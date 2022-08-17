#!/bin/bash

kubectl create ns immudb
kubectl create secret generic hook-secret --from-file=./secrets/passwords -n immudb

helm install immudb ../immudb -f values.yaml -f resource-values.yaml -n immudb
