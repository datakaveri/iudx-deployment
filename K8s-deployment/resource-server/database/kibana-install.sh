kubectl create secret generic kibana-keystore --from-file=./secrets/keystores/kibana.keystore  -n elastic
kubectl create secret generic kibana-certs --from-file=./secrets/pki/kibana-tls-cert --from-file=./secrets/pki/kibana-tls-key  -n elastic

