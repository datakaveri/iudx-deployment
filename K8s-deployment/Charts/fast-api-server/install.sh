kubectl create namespace icmr-fast-as
kubectl create configmap fast-api-env --from-env-file=secrets/.fast-api.env -n icmr-fast-as
kubectl create secret generic fast-api-config --from-env-file=secrets/config.env -n icmr-fast-as
helm install fast-api -f values.yaml -f resource-values.yaml ../../fast-api-server/SnomedSearch $@ -n icmr-fast-as

