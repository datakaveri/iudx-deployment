kubectl apply -f statefulset.yaml
kubectl autoscale statefulset rabbitmq -n rabbitmq-test --cpu-percent=75 --min=3 --max=5
