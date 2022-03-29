# AWS storage
Currently in-tree ebs storageclass is used ```kubernetes.io/aws-ebs```.

## Deploy ebs storage-class
1. Following command will deploy the storageclass
``` kubectl apply -f ebs-storageclass.yaml ```
## Deploy efs storage-class
1. Install aws-efs csi drivers by follwing the steps [here](https://github.com/kubernetes-sigs/aws-efs-csi-driver#installation)
2. Update the `efs-storageclass.yaml` with the created file system id.
3. Following command will deploy the storageclass
``` kubectl apply -f efs-storageclass.yaml ```

Note: efs-csi-driver might require create permission on secret resources in k8s. Which can be given by adding create verb under the appropriate resource in the yaml using the following commad: 

```console
$ kubectl get ClusterRole system:controller:persistent-volume-binder -o yaml
```
