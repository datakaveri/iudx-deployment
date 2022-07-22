kubectl create namespace fs
kubectl create configmap fs-env --from-env-file=secrets/.fs.env -n fs
kubectl create secret generic fs-config --from-file=secrets/config.json -n fs
helm install file-server  -f values.yaml -f resource-values.yaml ../file-server/ $@ -n fs
