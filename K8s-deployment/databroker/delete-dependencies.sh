kubectl delete -f internal-client-service.yaml
kubectl delete -f external-client-service.yaml
kubectl delete -f rabbitmq-logstash-client-service.yaml
kubectl delete -f headless-service.yaml
kubectl delete -f configmap.yaml
kubectl delete -f rbac.yaml
kubectl delete -f namespace.yaml

