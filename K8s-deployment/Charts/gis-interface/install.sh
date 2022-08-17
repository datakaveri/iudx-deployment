kubectl create namespace gis
kubectl create configmap gis-env --from-env-file=secrets/.gis-api.env -n gis
kubectl create secret generic gis-config --from-file=secrets/config.json -n gis
helm install gis-interface -f values.yaml -f resource-values.yaml  ../gis-interface/ $@ -n gis
