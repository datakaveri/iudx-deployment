# Nginx Ingress Controller
K8s community maintained [ingress-nginx](http://github.com/kubernetes/ingress-nginx) based on NGINX Open Source  is used as K8s ingress controller. 

## Design 
1. Architecture: Using  Load balancer in front of nginx-ingress controller as service. All HTTPS traffic pass through this load balancer service and routes to ingress-controller, which in-turn does host based  routing to IUDX servers defined in their respective ingress. TLS termination is done at ingress controller.

2. **Scalability** : Horizontal Pod Autoscaling for ingress-nginx has been implemented based on CPU usage. Target CPU utilization: 70%. 
3. **HA**: Minimum 2 replicas of nginx-ingress-controller with each being on different nodes. Use of Load Balancer as the entry point for HTTPS ingress traffic.
### Some Design decisions
1. Why Load Balancer in-front of ingress controller? <br>
Pods and nodes (cloud VMS) are not guaranteed to live for whole life time i.e. the ips might change. The load balancer (Kubernetes service) is a construct that stands as a single, fixed-service endpoint for a given set of pods or worker nodes. It acts as both a fixed referable address, handle higher network-bandwidth than what a single VM can handle and a load balancing mechanism.
2. Why TLS termination not at Load balancer? <br>
TLS termination at loadbalancer would involve certificates to be managed at loadbalancer and it will differ for every cloud vendor. TLS termination at ingress controller ensures its cloud vendor neutral and  certificates can be easily managed using certmanager tool.
3. Why use AWS network loadbalancer over the Application Load Balancer (ALB)? <br>
    - Source/remote address preservation
    - SSL termination will need to happen at the backend i.e. ingress controller
    - Static IP/elastic IP addresses <br>

    Ref: https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/ 
 
## Pre-requisites for deploying 
1. If deploying in aws, tag resources according to the docs mentioned [here](https://rancher.com/docs/rancher/v2.5/en/cluster-provisioning/rke-clusters/custom-nodes/#3-amazon-only-tag-resources).
2. Memcached Instance for Nginx Ingress Global Rate Limiting. Its included in the installer script.
3. Define resource values for memcached and ingress-nginx in respective directories in the file 'resource-values.yaml'. Please see the example of 'resource-values.yaml' for ingress-nginx, memcached present in their respective directories for reference.
## Deploy 

1. It can be installed using the ```./install.sh``` script.
## Note
1. This addon is available through Rancher, but is not used currently. The reason being ingress-nginx version used there is a older version and it does not support global rate limiting.
2. The ingress-nginx helm chart available [here](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx) is used.
3. The memcached helm chart  available [here](https://github.com/bitnami/charts/tree/master/bitnami/memcached) is used.
4. The nginx pods are deployed on two different nodes and memcache is deployed on one of the nodes where nginx is scheduled. This is done using pod affinity and anti-affinty, please define approriate resource values, keeping this in mind. If this configuration is not optimal, please adjust affinties and anti-affinities accordingly in their values file.
## Known Issues and Solutions
1. [Mulitple instances of memcached issue](https://github.com/kubernetes/ingress-nginx/issues/6849) : with having mulitple instances of memcached with nginx. Nginx unable to communicate with memcached host, resulting in global rate-limiting not working.<br>
Workaround Solution: For now single memcache instance is used.
2. [AWS NLB health-check fails](https://github.com/rancher/rancher/issues/22416#issue-485187046). <br>
Workaround Solution:
[Add --node-name when setting up K8s cluster using Rancher in cloud init scripts](https://github.com/rancher/rancher/issues/22416#issuecomment-531249541)
 
## TODO
1. Add architecture diagram
