# Install
This install Certmanager.
The helm chart is based on official Certmanager

## Define Appropriate values of resources
Define Appropiate resource values in ```resource-values.yaml``` as 
shown in sample resource-values file for [aws](example-aws-resource-values.yaml) and [azure](example-azure-resource-alues.yaml) deployment.

## Deploy
1. Update the Jetstack Helm repository
```
helm repo update jetstack
```
2. Create cert-manager namespace
```
kubectl create namespace cert-manager
```
3.  Helm install cert-manager in cert-manager namespace
```
helm install -f cert-manager-values.yaml -f resource-values.yaml  cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace  --version v1.13.3 --set installCRDs=true --set prometheus.enabled=false
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


# Cert-Manager Issuer
Here LetsEncrypt issuer is being used.

## Deploy
Before deploying, please define appropriate email-id required for letsencrypt issuer in [cert-manager-cluster-issuer.yaml](./cert-manager-cluster-issuer.yaml)

To Deploy Issuer
```
kubectl apply -f cert-manager-cluster-issuer.yaml 
```
## Uninstall Issuer
```
kubectl delete -f cert-manager-cluster-issuer.yaml
```
## Note: 
1. This will deploy and delete both stagging and production issuers. 
2. To uninstall a specific issuer, use following command

```
kubectl delete ClusterIssuer <name-of-issuer>
```
3. The Let’s Encrypt production issuer has [very strict rate limits](https://letsencrypt.org/docs/rate-limits/). 
Hence, use Let’s Encrypt staging issuer while experimenting and learning.

4. Please delete letsencrypt-staging issuer in production.
