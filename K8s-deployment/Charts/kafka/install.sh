./kafka_certs_generate.sh
helm repo add kafka https://charts.bitnami.com/bitnami
helm repo update
kubectl create ns kafka
kubectl create secret kafka-env --from-file=./config/.env
kubectl create secret generic certificates  --from-file=./kafka_certs/ca-cert --from-file=./kafka_certs/cert-file --from-file=./kafka_certs/cert-signed --from-file=./kafka_certs/kafka_password --from-file=./kafka_certs/keystore/kafka.keystore.jks --from-file=./kafka_certs/truststore/ca-cert  --from-file=./kafka_certs/truststore/ca-key  --from-file=./kafka_certs/truststore/kafka.truststore.jks --from-file=./configs/kafka_jaas.conf -n kafka
helm install --version=19.1.3 -f values.yaml -f resource.values.yaml -n kafka kafka/kafka
