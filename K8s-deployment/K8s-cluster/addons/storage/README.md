# Volumes, PVC  and storage
Persistent Volumes are used as volumes in following components to persist the various data in the pods:
1. Immudb - To persist api metering and log auditing
2. Elasticsearch - To persist the indices
3. Redis - To store redis snapshots, append file
4. Zookeeper - To persist vertx clustering information
5. File server api-server verticle/service - To persist files

Persistent volumes are provisioned dynamically using PVCs (Persistent Volume Claims) and Storageclass. 
PVC contains the details of amount storage required and what type of storageclass to use and other options.
When PVC K8s resource object with storageclass is created, the storage is dynamically provisioned from cloud  and a control loop in control plane will watch for new PVCs and  bind PVs to PVCs.

Two types of storageclass exist:
1. in-tree K8s storage class - will be depereacted in favour of CSI volume by 1.21 k8s version and does not accept new features
2. CSI volumes - 


Refer following:
1. https://kubernetes.io/docs/concepts/storage/persistent-volumes/ 
2. https://kubernetes.io/docs/concepts/storage/storage-classes/#aws-ebs
3. https://kubernetes.io/blog/2019/12/09/kubernetes-1-17-feature-csi-migration-beta/
