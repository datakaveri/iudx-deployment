# Cluster Autoscaler for Rancher with RKE2

This cluster autoscaler for Rancher scales nodes in clusters which use RKE2
provisioning (Rancher v2.6+). It uses a combination of the Rancher API and the
underlying cluster-api types of RKE2.

## Configuration

The `cluster-autoscaler` for Rancher needs a configuration file to work by
using `--cloud-config` parameter. Example configuration file - 
[config.yaml](./config.yaml).

## Create a CA user on Rancher

The Rancher server account provided in the `cloud-config` requires the Administrator Global Permissions on the Rancher server.

- On Rancher portal, go to Users and Authentication
- Click Create
- Set the User Credentials
- Assign the Administrator role in Global Permissions
- Create User
- Login to Rancher with the created CA user 
- From the top right User menu, Go to Account and API Keys
- Click on Create API Key
- Set the token expiry and keep the scope set to 'No Scope'
- Click on Create
- Note the bearer token which will be used in the `cloud-config`

*Note: As of version 2.6.x Bearer tokens do not work when assigned a scope. Therefore it has to be created without a scope.

## Enabling Autoscaling

In order for the autoscaler to function, the RKE2 cluster needs to be
configured accordingly. The autoscaler works by adjusting the `quantity` of a
`machinePool` dynamically. For the autoscaler to know the min/max size of a
`machinePool` we need to set a few annotations using the
`machineDeploymentAnnotations` field. That field has been chosen because
updating it does not trigger a full rollout of a `machinePool`.

```yaml
apiVersion: provisioning.cattle.io/v1
kind: Cluster
spec:
  rkeConfig:
    machinePools:
    - name: pool-1
      quantity: 1
      workerRole: true
      machineDeploymentAnnotations:
        cluster.provisioning.cattle.io/autoscaler-min-size: "1"
        cluster.provisioning.cattle.io/autoscaler-max-size: "3"
```
** Add annotation to all worker machinePools that need autoscaling*

** This can be added by editing the cluster configuration as yaml on Rancher*


## Deploy the Cluster Autoscaler
   
1. Add helm repo for cluster autoscaler 
```sh
helm repo add autoscaler https://kubernetes.github.io/autoscaler && helm repo update
```
2. Define Appropriate values of resources -
  - CPU of requests and limits
  - RAM of resuests and limits
as shown in sample resource value file present at [example-resource-values.yaml](./example-resource-values.yaml)
3. Create ca config secret
```sh
kubectl create secret generic ca-config --from-file=./config.yaml -n kube-system
```
4. Install cluster autoscaler through helm
```
helm install ca autoscaler/cluster-autoscaler --version 9.25.0 -n kube-system -f values.yaml
``` 
    
** For more information refer [here](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/rancher/README.md)*


