kubectl create namespace icmr-fhir-os
kubectl create configmap fhir-onboarding-env --from-env-file=secrets/.fhir-onboarding.env -n icmr-fhir-os
kubectl create secret generic fhir-onboarding-config --from-env-file=secrets/config.env -n icmr-fhir-os
helm install fhir-onboarding -f values.yaml -f resource-values.yaml ../fhir-onboarding-server/ $@ -n icmr-fhir-os
