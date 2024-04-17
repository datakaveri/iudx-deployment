kubectl create namespace dmp-apd
kubectl create configmap dmp-apd-env --from-env-file=secrets/.dmp-apd.env -n dmp-apd
kubectl create secret generic dmp-apd-config --from-file=secrets/config.json -n dmp-apd
helm install dmp-apd-server  -f values.yaml -f resource-values.yaml ../dmp-apd-server/ $@ -n dmp-apd
