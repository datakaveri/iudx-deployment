# Introduction
K8s addons are essential K8s workloads which along with K8s cluster enable deployment of actual application K8s workload. In our case which enables IUDX K8s deployment. 

* Currently, through Rancher following addons are installed
    * Network CNI (calico/canal)
    * DNS (CoreDNS)
    * Metrics server

* Extra addons deployed through sub-directories present by same name
    * adv-monstack: Helps monitor IUDX platform endpoints
    * Certmanager: Automatic certificate renewal for HTTPS ingress
    * Cluster Autoscaler
    * Ingress Controller
    * Monitoring Stack (mon-stack): K8s Observabilty Stack
    * Storage: Storage drivers, classes for PVs
    * Velero: K8s PV backup addon
