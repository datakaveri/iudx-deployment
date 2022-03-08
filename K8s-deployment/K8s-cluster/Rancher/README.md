# Rancher
Rancher server is a tool to manage multiple K8s cluster	across any infrastructure i.e any cloud providers or bare-metal servers.
## Design 
1. Architecture: Rancher server in IUDX is used to install [RKE distribution](https://rancher.com/docs/rke/latest/en/) K8s cluster and manage the Cluster across multiple clouds.
Rancher server is used to provision K8s cluster using custom nodes [currently](#notes). See architecture diagram below. 
<p align="center">
<img src="../../../docs/rancher-architecture-rancher-api-server.svg">
</p>
Fig. 1: Rancher server Architecture , image Ref: https://rancher.com/docs/rancher/v2.5/en/overview/architecture/ 

2. **HA of Rancher**:  Rancher can deployed in[HA setup](https://rancher.com/docs/rancher/v2.5/en/installation/#high-availability-kubernetes-install-with-the-helm-cli) by deploying it as K8s application in a K8s cluster. It also provides a [easy backup solution](https://rancher.com/docs/rancher/v2.5/en/backups/).



## Installation
1. Rancher can be [installed in two ways](https://rancher.com/docs/rancher/v2.5/en/installation/). The below installation is based on single-node docker install
   
2. Define appropriate compose definitions in docker-compose.custom.yaml to override the base compose file(docker-compose.yaml).The definition can depend on where and for what pupose (test, production, machine specs) its deployed. An example is present for reference.
```sh
# Run Rancher server in docker using docker-compose
docker-compose -f docker-compose.yaml -f docker-compose.custom.yaml up -d
```

## Notes
1. Why Rancher is used to orchestrate (install, manage) K8s cluster and not managed K8s service?
   - The most important reason for using Rancher are as follows:
      - Easy orchestration (install, manage, delete) of multiple K8s cluster
      - Be able to deploy K8s cluster on any cloud through OSS tool i.e. be cloud agnostic. 
2. Why K8s Cluster is installed using custom nodes option in Rancher?
   - Rancher gives two methods to [launch K8s cluster from Rancher (i.e. create RKE clusters)](https://rancher.com/docs/rancher/v2.5/en/cluster-provisioning/rke-clusters/)
      1. With RKE and new nodes in an infrastructure provider using nodepool
      s (which in turn used docker machine)
      2. Custom existing nodes :  With RKE and existing bare-metal servers or virtual machines. 
   - The second option is used to install K8s cluster, mainily for following reasons
      1. Integration of cluster autoscaler is not natively present with Rancher. Refer these issues - [Adding rancher as cloud provider in ca :](https://github.com/kubernetes/autoscaler/pull/4041) and [Rancher 2.0 & Cluster Autoscaling](https://github.com/rancher/rancher/issues/15145). Its currently possible with only [custom nodes and cloud init scripts](https://rancher.com/docs/rancher/v2.5/en/cluster-admin/cluster-autoscaler/).

3. The necessary documentation and files for creating K8s cluster on a cloud is present in directory - configs/\<cloud-provider-name\>.
4. Extra addons needed on top of this install of RKE distribution is present in [directory](../addons/). Basically, addons are K8s based applications which facilitate the proper functioning of actual workload - i.e. the IUDX system deployed in K8s. 
5. Currently, through Rancher [following addons are installed](https://rancher.com/docs/rke/latest/en/config-options/add-ons/)
  - Network CNI (calico/canal)
  - DNS (CoreDNS)
  - Metrics server

