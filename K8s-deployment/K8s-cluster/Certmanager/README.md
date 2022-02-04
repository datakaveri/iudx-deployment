# Install
This install Certmanager.
The helm chart is based on official Certmanager

## Define Appropriate values of resources
Define Appropiate resource values in ```resource-values.yaml```.
An example is given in example-resource-values.yaml.

## Deploy
1. Add the Jetstack Helm repository and Update
```
helm repo add jetstack https://charts.jetstack.io && helm repo update
```
2. Create cert-manager namespace
```
kubectl create namespace cert-manager
```
3. Helm install cert-manager in cert-manager namespace
```
helm install -f cert-manager-values.yaml -f resource-values.yaml  cert-manager jetstack/cert-manager --namespace cert-manager  --create-namespace  --version  v1.6.1 --set installCRDs=true
```
## Uninstalling with Helm
1. Uninstalling cert-manager from a helm installation using the delete command on helm.
```
helm --namespace cert-manager delete cert-manager
```
2. Delete the cert-manager namespace:

```
kubectl delete namespace cert-manager
```

3. Finally, delete the cert-manger CustomResourceDefinitions using the link to the version v1.6.1 you installed: 

```
kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.crds.yaml
```
Note: This command will also remove installed cert-manager CRDs and all cert-manager resources (e.g. certificates.cert-manager.io resources) by Kubernetes' garbage collector.

