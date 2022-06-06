kubectl apply -f namespace.yaml
kubectl create secret generic certs --from-file=./secrets/pki/rabbitmq-ca-cert.pem --from-file=./secrets/pki/rabbitmq-server-cert.pem --from-file=./secrets/pki/rabbitmq-server-key.pem -n rabbitmq
kubectl create secret generic rabbitmq-erlang-cookie --from-file=./secrets/credentials/.erlang.cookie -n rabbitmq
kubectl create secret generic rabbitmq-definition-file --from-file=./secrets/credentials/rabbitmq-definitions.json -n rabbitmq
kubectl apply -f rbac.yaml
kubectl apply -f configmap.yaml
kubectl apply -f external-client-service.yaml
kubectl apply -f internal-client-service.yaml
kubectl apply -f rabbitmq-logstash-client-service.yaml 
kubectl apply -f headless-service.yaml

