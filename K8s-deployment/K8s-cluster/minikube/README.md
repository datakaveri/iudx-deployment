# Minikube

## Minikube install
Follow the instructions to install : https://minikube.sigs.k8s.io/docs/start/#binary-download

## Minikube setup
```sh
# Starts a control-plane + worker node
minikube start --network-plugin=cni --cni=calico

# Adds worker nodes
minikube node add
minikube node add

# List nodes and IPs
minikube node list

# List nodes and statuses
minikube status
```

## Minikube stripdown
```sh
# Stop a node (volumes are persisted)
minikube stop minikube-m02

# Stop all nodes (volumes are persisted)
minikube stop

# Delete a node (volumes are lost)
minikube delete minikube-m02

# Delete all nodes (volumes are lost)
minikube delete
```

