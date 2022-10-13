kubectl create ns adv-monstack
kubectl create secret generic advance-config --from-file=./a.txt --from-file=./a.zip --from-file=./secrets/adv-mon-stack-conf.json -n adv-monstack
kubectl apply -f adv-monstack.yaml
