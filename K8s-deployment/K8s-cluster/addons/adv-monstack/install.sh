kubectl create ns adv-monstack
kubectl create secret generic advance-config  --from-file=./secrets/adv-mon-stack-conf.json -n adv-monstack
kubectl apply -f adv-monstack.yaml
