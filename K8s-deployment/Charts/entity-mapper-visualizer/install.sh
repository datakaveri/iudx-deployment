kubectl create namespace icmr-entity-mv
kubectl create configmap entity-mv-env --from-env-file=secrets/.entity-mv.env -n icmr-entity-mv
helm install entity-mv -f values.yaml -f resource-values.yaml ../entity-mapper-visualizer/ $@ -n icmr-entity-mv
