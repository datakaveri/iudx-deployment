# Introduction
* Various flavours of K8s distribution is available. We have tested 4.5.0 IUDX deployment against the following  matrix of differents K8s clusters, K8s versions and cloud provider 

    | K8s cluster | K8s version      | Cloud Provider(s) |
    |-------------|------------------|----------------|
    | RKE1        |  v1.24.8         | Azure          |
    | **RKE2**        | **v1.24.9+rke2r2**  | **AWS**            |
    | AKS         | v1.24.9          | Azure          |
    
  \* The highighted one is the most preferred
* In general, IUDX K8s deployment is compatabile and be integrated with any K8s cluster distribution as long as certain requirements are met
  
* Following is brief description of what each sub-directory has:

    * **RKE1** directory contains RKE1 K8s related configs and on how to deploy RKE1 through ranncher for IUDX
    * **RKE2** directory contains RKE2 K8s related configs and on how to deploy RKE1 through ranncher for IUDX
    * **minikube** directory contains on how to deploy minikube locally and how to use it for testing
    * **tests** directory contains tests to test K8s cluster functioning