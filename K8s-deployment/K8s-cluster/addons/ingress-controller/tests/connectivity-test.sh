#!/bin/bash
# test borrowed from tutorial https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/
kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment web --type=ClusterIP --port=8080
kubectl apply -f example-ingress-grl.yaml
# map the loadabalncer ip to hello-world.info in your hosts file
curl -vvv -k https://hello-world.info
# output should be 
# Hello, world!
# Version: 1.0.0
# Hostname: web-55b8c6998d-8k564

# test global rate limiting
ab -v 3 -n 200 -c 50 https://hello-world.info/  > /tmp/logs-grl.txt
cat /tmp/logs-grl.txt | grep 429
# atleast some requests will be rejected with 429 status cpde
sleep 10

# test rate limiting per ip
kubectl apply -f example-ingress-rps.yaml
ab -v 3 -n 200 -c 50 https://hello-world.info/  > /tmp/logs-rps.txt
cat /tmp/logs-rps.txt | grep 429
# atleast some requests will be rejected with 429 status cpde
sleep 10

# test connections limit
kubectl apply -f example-ingress-connections.yaml
ab -v 3 -n 200 -c 50 https://hello-world.info/  > /tmp/logs-conns.txt
cat /tmp/logs-conns.txt | grep 503
# atleast some requests will be rejected with 503 status cpde

kubectl apply -f example-ingress-grl.yaml

