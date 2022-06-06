kubectl apply -f statefulset.yaml
kubectl autoscale statefulset rabbitmq -n rabbitmq --cpu-percent=75 --min=3 --max=5
