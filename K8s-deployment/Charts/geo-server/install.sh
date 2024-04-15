#! /bin/bash

kubectl create namespace ugix-geoserver
kubectl create configmap geoserver-env --from-env-file=./secrets/.geoserver.env -n ugix-geoserver
kubectl create secret generic geoserver-config --from-file=./secrets/config.json -n ugix-geoserver
helm install geo-server ../geo-server -f values.yaml -f resource-values.yaml $@ -n ugix-geoserver
