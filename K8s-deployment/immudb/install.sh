#! /bin/sh

kubectl create secret generic immudb-admin-password --from-file=./secrets/immudb-admin-password -n immudb
helm install immudb ../immudb -f values.yaml -f resource-values.yaml -n immudb
