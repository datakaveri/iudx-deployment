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

   This flag can be enabled in rancher server, through advanced cluster configuration.

2.  Install the drivers by following the steps [here](https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/install.md#installation)
3. Deploy the storage class
```console
kubectl apply -f ebs-csi-storageclass.yaml
```

## Deploy efs storage-class
1. Create an EFS on AWS by following the steps mentioned [here](https://docs.aws.amazon.com/efs/latest/ug/gs-step-two-create-efs-resources.html) 
2. Install aws-efs csi drivers by follwing the steps [here](https://github.com/kubernetes-sigs/aws-efs-csi-driver#installation)
3. Update the `efs-storageclass.yaml` with the created file system id.
4. Following command will deploy the storageclass
```console
kubectl apply -f efs-storageclass.yaml 
```

*Note: Add an Inbound rule in the security group of the EFS to allow TCP traffic at port 2049 (NFS) with security group of the worker nodes as the source.
