# Cluster Autoscaling

[Cluster Autoscaler (CA)](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) is a tool that automatically adjusts the size of the Kubernetes cluster when one of the following conditions is true:
  -  there are pods that failed to run in the cluster due to insufficient resources.
  -  there are nodes in the cluster that have been underutilized for an extended period of time and their pods can be placed on other existing nodes.

CA is concerned with only increase or decrease of k8s cluster nodes. It is not concerned with making the nodes join the K8s cluster, its left to K8s cluster manager/installer to take care of it. Because the cluster autoscaler cloud dependent, there is specific code for each cloud provider CA. Each cloud-provider specific CA is generally well tested with cloud provider's K8s managed service.

Two ways to do with Rancher 
1. Rancher Native way :- Using nodepools of Rancher, abstracting the cloud-provider. This would be best way if there is good support from Rancher. But this is still in PR stage  https://github.com/kubernetes/autoscaler/pull/4041.
2.  Integrate Rancher, cluster autoscaler and cloud init script : Following is a summary of how to do it and works:

    1) The [Cluster autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/aws) just modifies cloud specific scaling group (Eg: ASG in aws, VMSS in azure) with desired number according to the conditions.

    2) The cloud specific scaling group will create the new VM from template.

    3) VM cloud init will install per-requisite k8s things on that VM and contacts rancher server through Rancher agent.

    4) Rancher server will make it join to the K8s cluster. Refer: https://rancher.com/docs/rancher/v2.5/en/cluster-admin/cluster-autoscaler/ .

## Notes
1. CA respect node affinity/selector when selecting [node groups to scale up](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#does-ca-respect-node-affinity-when-selecting-node-groups-to-scale-up). Particularly when node-selector based on instance type is used, the [instance type is automatically labeled](https://kubernetes.io/docs/reference/labels-annotations-taints/#nodekubernetesioinstance-type) by kubelet if configured with cloud provider.
