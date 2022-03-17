#!/bin/bash
kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment web --type=ClusterIP --port=8080
kubectl apply -f https://k8s.io/examples/service/networking/example-ingress.yaml
# map the loadabalncer ip to hello-world.info in your hosts file
curl -vvv hello-world.info
