#! /bin/bash
# Script commands
kubectl create ns rabbitmq
kubectl create secret generic certs --from-file=./secrets/pki/ca.crt --from-file=./secrets/pki/tls.crt --from-file=./secrets/pki/tls.key -n rabbitmq
kubectl create secret generic rabbitmq-erlang-cookie --from-file=./secrets/credentials/rabbitmq-erlang-cookie -n rabbitmq
kubectl create secret generic rmq-passwords --from-file=./secrets/credentials -n rabbitmq
kubectl create secret generic rabbitmq-admin-password --from-file=rabbitmq-password=./secrets/credentials/admin-password -n rabbitmq
kubectl create configmap rmq-init-config --from-file=./secrets/init-config.json -n rabbitmq
kubectl apply -f minikube-service.yaml -n rabbitmq
helm repo update bitnami
helm install rabbitmq bitnami/rabbitmq -f minikube-values.yaml -f minikube-resources.yaml -n rabbitmq --version 12.6.2
kubectl apply -f rmq-init-setup.yaml 
