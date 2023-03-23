# RKE2 Cluster Setup
## Setting up the amazon cloud provider
## 1. Create IAM Roles with policies
### 1.1 Master Role
- This policy is for the nodes with the controlplane role. These nodes have to be able to create/remove EC2 resources.
```
<placeholder>
```
### 1.2 Worker Role
- This policy is for the nodes with the etcd or worker role. These nodes only have to be able to retrieve information from EC2.
```
<placeholder>
```
- Policy for using encrypted ebs volumes 
```
<placeholder>
```
- Policy for using EFS volumes
```
<placeholder>
```
## 2. Create IAM User for rancher
- Create user with following policy
```
<placeholder>
```
- Generate Access key and Secret key for the IAM user. Refer [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey).


# Creating Cluster on Rancher
## Pre-requisite
- Create a VPC/subnet for cluster resources.
- Create a security group with appropriate rules for rancher cluster (Optional. Rancher creates this for you if not created. It can later be modified as well.)

## 1. Create your cloud credentials

If you already have a set of cloud credentials to use, skip this section.

- Click ☰ > Cluster Management.
- Click Cloud Credentials.
- Click Create.
- Click Amazon.
- Enter a name for the cloud credential.
- In the Default Region field, select the AWS region where your cluster nodes will be located. 
- Enter your AWS EC2 Access Key and Secret Key.
- Click Create.

Result: You have created the cloud credentials that will be used to provision nodes in your cluster. You can reuse these credentials for other node templates, or in other clusters.
## 2. Create your cluster
- Click ☰ > Cluster Management.
- On the Clusters page, click Create.
- Toggle the switch to RKE2/K3s.
- Click Amazon EC2.
- Select a Cloud Credential, if more than one exists. Otherwise, it's preselected.
- Enter a Cluster Name.
- Create a machine pool for each Kubernetes role. (Multiple for worker role to have different instance types)
	- For each machine pool, define the machine configuration/instance types, region, and zones.
	- Pass the Master and Worker roles created in previous steps in the `IAM instance Profile Name` field in respective machine pools.
    - Select correct VPC/Subnet and Security group. (or let rancher create one for you)
    - Enable `Allow access to EC2 metadata`.
- Use the Cluster Configuration to choose the version of Kubernetes that will be installed, what network provider will be used and if you want to enable project network isolation.
	- Tested with k8s version `v1.24.9+rke2r2`, Cloud Provider `Amazon`, Container Network `calico`.
- Use Member Roles to configure user authorization for the cluster. Click Add Member to add users that can access the cluster. Use the Role drop-down to set permissions for each user.
- Click Create.

***Tag the VPC/Subnet and Security group with Key = `kubernetes.io/cluster/CLUSTERID` Value = `owned`.
`CLUSTERID` can be any string you like, as long as it is equal across all tags set. (Match tags of the cluster nodes brought up by Rancher)***

***Starting with Kubernetes 1.23, you have to deactivate the CSIMigrationAWS feature gate in order to use the in-tree AWS cloud provider. You can do this by setting feature-gates=CSIMigrationAWS=false as an additional argument for the cluster's Kubelet, Controller Manager, API Server and Scheduler in the advanced cluster configuration.***

### References
- [https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup/set-up-cloud-providers/amazon](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup/set-up-cloud-providers/amazon)
- [https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/create-an-amazon-ec2-cluster](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/create-an-amazon-ec2-cluster)