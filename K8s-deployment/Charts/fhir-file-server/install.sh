kubectl create namespace icmr-fhir-fs
kubectl create configmap fhir-fs-env --from-env-file=secrets/.fs.env -n icmr-fhir-fs
kubectl create secret generic fhir-fs-config --from-env-file=secrets/config.env -n icmr-fhir-fs
helm install fhir-file-server  -f values.yaml -f resource-values.yaml ../fhir-file-server/ $@ -n icmr-fhir-fs
