kubectl create namespace onboarding
kubectl create configmap onboarding-env --from-env-file=secrets/.onboarding.env -n onboarding
kubectl create secret generic onboarding-config --from-file=secrets/config.json -n onboarding
helm install onboarding-server  -f values.yaml -f resource-values.yaml ../onboarding-server/ $@ -n onboarding
