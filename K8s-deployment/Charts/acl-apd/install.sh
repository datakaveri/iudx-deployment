kubectl create namespace acl-apd
kubectl create configmap apd-env --from-env-file=secrets/.apd.env -n acl-apd
kubectl create secret generic apd-config --from-file=secrets/config.json -n acl-apd
helm install acl-apd -f values.yaml -f resource-values.yaml ../acl-apd/ $@ -n acl-apd
