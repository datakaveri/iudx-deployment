# Installation of Sealed secrets

1. Controller Installation

```
helm install --version 1.16.1 --namespace kube-system sealed-secrets-controller  sealed-secrets/sealed-secrets
```
2. Kubseal client installation

```
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-linux-amd64 -O kubeseal
&& sudo install -m 755 kubeseal /usr/local/bin/kubeseal

```
# Using kubeseal & sealed secrets

1. Obtain sealed-secret public key

In K8s cluster with sealed secrets controller deployed, use following command
```
kubeseal --fetch-cert > sealed-secrets-pub.pem 
```
2. Use the public certificate to encrypt the secrets in  offline K8s cluster

``` 
# create a new sealed secret 
kubectl create secret generic <secret-name>  --dry-run=client --from-file=<file-name> -n <namespace-name>  -o yaml | kubeseal --cert sealed-secrets-pub.pem  --format yaml >  <sealed-secret-name>.yaml

# add/update secrets of a sealed  secret
 kubectl create secret generic <existing-secret-name> --dry-run=client --from-file=<file-name> -n <namespace-name>-o yaml | kubeseal --cert  sealed-secrets-pub.pem --format yaml  --merge-into <existing-sealed-secret-name>.yaml

```
3. Deploy the sealed secret 

In K8s cluster with sealed secrets controller deployed, use following command

```
kubectl apply -f <sealed-secret-name>.yaml
```

# Create docker registry credentials

1. ``` docker login <registry-name> ``` and copy the ~/.docker/config.json to secrets/docker-registry-login
2. create sealed secret  using 

```
 kubectl create secret generic regcred     --from-file=.dockerconfigjson=./secrets/docker-registry-login --type=kubernetes.io/dockerconfigjson  --dry-run=client -o yaml |  kubeseal --cert  sealed-secrets-pub.pem --scope cluster-wide  --format yaml  >  cluster-wide-sealed-secrets/docker-registry-cred.yaml
``` 
