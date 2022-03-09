# Azure CLuster Autoscaler

## Pre-requisites
1. K8s cluster needs to be installed from Rancher using VMSS on azure, documented [here](https://wiki.iudx.io/books/k8s-notes/page/setting-up-k8s-cluster-on-azure).
2. The worker node VMSS needs to be tagged with keys 
```cluster-autoscaler-enabled=true```,
```cluster-autoscaler-name=<cluster-name>``` to enable proper autodiscovery of VMSS of K8s cluster, ```min``` and ```max``` values denoting the minimum and maximum number of VMs that can be spawned for that specific VMSS. 

## Create CA yaml
- Fill in the [`cluster-autoscaler-autodiscover.yaml`](./cluster-autoscaler-autodiscover.yaml) file with appropriate azure cloud details and the k8s cluster name in ```--node-group-auto-discovery=label:cluster-autoscaler-enabled=true,cluster-autoscaler-name=<YOUR CLUSTER NAME>```

## Deploy
1. ``` kubectl apply -f cluster-autoscaler-autodiscover.yaml```

## Notes
1. Auto-discovery of VMSS is configured. This allows discovery of VMSS automatically, helps when multi-asg (with each one corresponding to different instance type) is used.
2. The CA is configured to run on control plane, by updating the tolerations, nodeSelector - to avoid eviction of CA pod during scale down of worker nodes.
3. The version cluster autoscaler must be same as the [K8s control plane version installed.](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler#releases)
