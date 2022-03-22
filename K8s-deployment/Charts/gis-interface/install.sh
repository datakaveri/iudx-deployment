kubectl create namespace rs
kubectl create configmap gis-env --from-env-file=.gis-api.env -n gis
kubectl create secret generic gis-config --from-file=secrets/configs/config.json -n gis
helm install gis-interface -f resource-values.yaml -f values.yaml gis-interface/ -n gis