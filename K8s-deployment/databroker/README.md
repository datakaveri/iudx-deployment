# RabbitMQ cluster in k8s as a StatefulSet
## Required Secrets
```sh
secrets/
├── credentials
│   ├── rabbitmq-admin-passwd
│   └── rabbitmq-definitions.json
└── pki
    ├── rabbitmq-ca-cert.pem (letsencrpt chain.pem)
    ├── rabbitmq-server-cert.pem (letsencrpt fullchain.pem)
    └── rabbitmq-server-key.pem (letsencrpt privkey.pem)

```
## Required storage class
```sh
# For ebs as storage class, deploy ebs-storage class in K8s cluster if not present
kubectl apply -f ../../K8s-cluster/addons/storage/aws/ebs-storageclass.yaml
```
## Required cluster-autoscaler
```sh
# Deploy cluster-autoscaler if not present in K8s cluster
kubectl apply -f ../../K8s-cluster/cloud-specific/aws/cluster-autoscaler-autodiscover.yaml
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
kubectl -n rabbitmq get pods -o wide

# RabbitMQ pod logs
kubectl logs -n rabbitmq -f POD_NAME
```
## To dos:
1. Integration of cert-manager and TLS certs of RMQ
2. Prometheus operator integration with RMQ monitoring
3. Differentiate following things between environements - dev(mostly deployed in minikube), test and production mostly using Kustomize:
   - Persistent Volumes (PV)  
   - resource requests and limits
   - namespace naming
## References
1. [RabbitMQ in k8s using StatefulSet in Minikube](https://github.com/rabbitmq/diy-kubernetes-examples/tree/master/minikube)
2. [Rabbitmq in k8s using Statefulset in cloud-specific](https://github.com/rabbitmq/diy-kubernetes-examples/tree/master/gke)
3. [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/aws)
