kubectl create namespace auditing
kubectl create configmap auditing-env --from-env-file=secrets/.auditing.env -n auditing
kubectl create secret generic auditing-config --from-file=secrets/config.json -n auditing
helm install auditing-server  -f values.yaml -f resource-values.yaml ../auditing-server/ $@ -n auditing
