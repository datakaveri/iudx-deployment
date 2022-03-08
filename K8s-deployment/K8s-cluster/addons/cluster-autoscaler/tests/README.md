# Testing Cluster Autoscaling
1. Docs at https://rancher.com/docs/rancher/v2.5/en/cluster-admin/cluster-autoscaler/amazon/#generating-load is used to generate load test cluster autoscaling.
2. The hello pod used in above docs is present as cluster-autoscaler-test.yaml. The resouce request values needs to be adjuested to exhaust the Kubernetes cluster resources. Once the test deployment is prepared, deploy it in the Kubernetes cluster default namespace (Rancher UI can be used instead):
``` kubectl -n default apply -f cluster-autoscaler-test.yaml```
