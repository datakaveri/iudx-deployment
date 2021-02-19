# RabbitMQ cluster in k8s as a StatefulSet
## Required Secrets
```sh
../../secrets/
├── passwords
│   ├── rabbitmq-definitions.json
│   └── rabbitmq-erlang-cookie
└── pki
    ├── ca-cert.pem (letsencrpt chain.pem)
    ├── server-cert.pem (letsencrpt fullchain.pem)
    └── server-key.pem (letsencrpt privkey.pem)
```
## Required storage class
```sh
# For ebs as storage class
kubectl apply -f ../../K8s-cluster/cloud-specific/aws/ebs-storageclass.yaml
```
## Deploy
#### Dependencies
```sh
# Deploy dependencies
./deploy-dependencies.sh

# Delete dependencies
./delete-dependencies.sh
```

#### StatefulSet
```sh
# Deploy statefulset, launches 3 pods
./deploy-statefulset.sh

# Delete statefulset
./delete-statefulset.sh
```

#### Helpers
```sh
# Pod status, IP, node, etc
kubectl -n rabbitmq-test get pods -o wide

# RabbitMQ pod logs
kubectl logs -n rabbitmq-test -f POD_NAME
```
## To dos:
1. Integration of cert-manager and TLS certs of RMQ
2. Prometheus operator integration with RMQ monitoring
3. Differentiate following things between env, mostly using Kustomize:
   - Persistent Volumes (PV)  
   - resource requests and limits
   - namespace naming
## References
1. [RabbitMQ in k8s using StatefulSet in Minikube](https://github.com/rabbitmq/diy-kubernetes-examples/tree/master/minikube)
2. [Rabbitmq in k8s using Statefulset in cloud-specific](https://github.com/rabbitmq/diy-kubernetes-examples/tree/master/gke)
