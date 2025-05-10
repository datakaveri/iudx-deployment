kubectl create namespace icmr-fhir-rs
kubectl create configmap fhir-rs-env --from-env-file=secrets/.fhir-rs.env -n icmr-fhir-rs
kubectl create secret generic fhir-rs-config --from-file=secrets/config.json -n icmr-fhir-rs
kubectl create secret generic application-yaml --from-file=secrets/application.yaml -n icmr-fhir-rs
helm install fhir-rs -f values.yaml -f resource-values.yaml ../fhir-resource-server/ $@ -n icmr-fhir-rs
