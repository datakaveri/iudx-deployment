#! /bin/bash

kubectl create namespace rs
kubectl create configmap rs-env --from-env-file=./secrets/.rs-api.env -n rs
kubectl create secret generic rs-s3-env --from-file=./secrets/AWS_ACCESS_KEY_ID --from-file=./secrets/AWS_SECRET_ACCESS_KEY -n rs
kubectl create secret generic rs-config --from-file=./configs/config.json -n rs
helm install resource-server ../resource-server -f values.yaml -f resource-values.yaml -n rs