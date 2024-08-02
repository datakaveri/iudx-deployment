#! /bin/bash

kubectl create namespace geoserver
kubectl create configmap geoserver-env --from-env-file=./secrets/.geoserver.env -n geoserver
kubectl create secret generic geoserver-config --from-file=./secrets/config.json -n geoserver
helm install geo-server ../geo-server -f values.yaml -f resource-values.yaml $@ -n geoserver
