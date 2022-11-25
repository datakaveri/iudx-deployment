kubectl create ns rabbitmq
kubectl create secret generic certs --from-file=./secrets/pki/ca.crt --from-file=./secrets/pki/tls.crt --from-file=./secrets/pki/tls.key -n rabbitmq
kubectl create secret generic rabbitmq-erlang-cookie --from-file=./secrets/credentials/rabbitmq-erlang-cookie -n rabbitmq
kubectl create secret generic rabbitmq-definition-file --from-file=./secrets/credentials/rabbitmq-definitions.json -n rabbitmq
kubectl create secret generic rabbitmq-admin-password --from-file=./secrets/credentials/rabbitmq-password -n rabbitmq
kubectl apply -f external-client-service.yaml
helm install rabbitmq bitnami/rabbitmq -f values.yaml -f resource-values.yaml -n rabbitmq --version 10.1.14
