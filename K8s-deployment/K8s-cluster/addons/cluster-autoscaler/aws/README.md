# AWS CLuster Autoscaler

## Pre-requisites
1. K8s cluster needs to be installed from Rancher, documented [here](../../../Rancher/configs/aws/).
2. The worker node ASG needs to be tagged with keys 
```k8s.io/cluster-autoscaler/enabled```,
```k8s.io/cluster-autoscaler/<cluster-name>``` to enable proper autodiscovery of ASG of K8s cluster. It then needs to be updated with apprpriate ```<cluster-name>``` in ```cluster-autoscaler-autodiscover.yaml ``` file.

## Deploy
1. ``` kubectl apply -f cluster-autoscaler-autodiscover.yaml```

## Notes
1. Auto-discovery of ASG is configured. This allows discovery of ASGs automatically, helps when multi-asg (with each one corresponding to different instance type) is used.
2. The CA is configured to run on control plane, by updating the tolerations, nodeSelector - to avoid eviction of CA pod during scale down of worker nodes.
3. The version cluster autoscaler must be same as the [K8s control plane version installed.](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler#releases)