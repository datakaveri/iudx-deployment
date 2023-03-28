# RKE2 Rancher-HA Setup

## Setup Infra on AWS
- Create VPC
- Create Subnet in created VPC
- Create Internet Gateway and Attach to the created VPC
- Create route table and associate with created subnet
	- Create a route in the rtb with destination `0.0.0.0/0` and Target as the created gateway
- Create a security group with the [following](https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-requirements/port-requirements#ports-for-rancher-server-nodes-on-rke2) rules
- Create a launch template for the Rancher HA vms
	- AMI: Ubuntu 22.04
    - Instance type: t3a.large
    - attach created security group
    - auto-assign public IP: Enable
    - use gp3 volume
    - unlimited credit specification
    - EBS-optimized instance: Enable
- Create autoscaling group using created launch template
	- Set Desired, Minimum, and Maximum capacities to 3
- Create target groups
	- target type: Instances
    - protocol: TCP
    - ports
    	- 80
        - 443
        	- Health check Override to port 80
        - 9345
        - 6443
    - Health check
    	- Healthy, Unhealthy THreshold: 3
    	- timeout: 6s
        - Interval 10s
	- Register targets
    	- add the 3 Rancher HA nodes created by the ASG
    - refer [here](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/infrastructure-setup/amazon-elb-load-balancer#1-create-target-groups) for more information.
- Create EIP for the loadbalancer
- Create Network Load Balancer
	- Internet Facing
    - Add listener for the 80, 443, 9345, and 6443 ports with forwarding to respective target group
	- Use created EIP as IPv4 address
- Create DNS mapping for the loadbalancer IP

## Setup RKE2 Cluster for Rancher HA 
Follow documentation [here](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-cluster-setup/rke2-for-rancher)

## Install Rancher HA on RKE2 cluster
### Pre-prequisite
- Install kubectl and helm cli
- Install certmanager in the cluster
	- install from iudx-deployment repo.
### Installation

- `helm repo add rancher-stable https://releases.rancher.com/server-charts/stable && helm repo update`
- `kubectl create namespace cattle-system`
- Install Rancher helm chart:
  ```
    helm install rancher rancher-stable/rancher \
    --namespace cattle-system \
    --set hostname=rke2-rancher.iudx.org.in \
    --set bootstrapPassword=admin \
    --set ingress.tls.source=letsEncrypt \
    --set letsEncrypt.email=admin.cloud@datakaveri.org \
    --set letsEncrypt.ingress.class=nginx \
    --version 2.7.1
  ```

- For more information, refer documentation [here](https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster)

## Backup and Restore of Rancher
1. Please refer [official docs](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/back-up-rancher) to backup rancher using Rancher Backup Operator
2.  Please refer [official docs](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/restore-rancher) to restore rancher backup
