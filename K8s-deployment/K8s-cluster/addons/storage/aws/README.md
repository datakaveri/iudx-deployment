# AWS storage

## Deploy ebs storage-class
This uses in-tree ``kubernetes.io/aws-ebs`` provsioner.
1. Following command will deploy the storageclass
```console 
kubectl apply -f ebs-storageclass.yaml 
```

## Deploy ebs-csi storage class
1. pre-requisites : 
        - Enable flag --allow-privileged=true for kube-apiserver
	- Enable kube-apiserver feature gates --feature-gates=CSINodeInfo=true,CSIDriverRegistry=true,CSIBlockVolume=true,VolumeSnapshotDataSource=true
        - Enable kubelet feature gates --feature-gates=CSINodeInfo=true,CSIDriverRegistry=true,CSIBlockVolume=true
   This is enabled in rancher server, through RKE manifest.

2.  Install the drivers by following the steps [here](https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/install.md#installation-1)
3. Deploy the storage class
```console
kubectl apply -f ebs-csi-storageclass.yaml
```

## Deploy efs storage-class
1. Install aws-efs csi drivers by follwing the steps [here](https://github.com/kubernetes-sigs/aws-efs-csi-driver#installation)
2. Update the `efs-storageclass.yaml` with the created file system id.
3. Following command will deploy the storageclass
```console
kubectl apply -f efs-storageclass.yaml 
```

Note: efs-csi-driver might require create permission on secret resources in k8s. Which can be given by adding create verb under the appropriate resource in the yaml using the following commad: 

```console
$ kubectl get ClusterRole system:controller:persistent-volume-binder -o yaml
```
