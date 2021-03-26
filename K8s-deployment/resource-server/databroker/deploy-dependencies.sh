kubectl apply -f namespace.yaml
kubectl create secret generic certs --from-file=../../secrets/pki/ca-cert.pem --from-file=../../secrets/pki/server-cert.pem --from-file=../../secrets/pki/server-key.pem -n rabbitmq-test
kubectl create secret generic rabbitmq-erlang-cookie --from-file=../../secrets/credentials/rabbitmq-erlang-cookie -n rabbitmq-test
kubectl create secret generic rabbitmq-definition-file --from-file=../../secrets/credentials/rabbitmq-definitions.json -n rabbitmq-test
kubectl apply -f rbac.yaml
kubectl apply -f configmap.yaml
kubectl apply -f external-client-service.yaml
kubectl apply -f internal-client-service.yaml
kubectl apply -f headless-service.yaml

