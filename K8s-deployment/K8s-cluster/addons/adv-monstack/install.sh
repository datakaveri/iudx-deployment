kubectl create ns adv-monstack
kubectl create secret generic advance-config --from-file=./a.txt --from-file=./a.zip --from-file=./adv-mon-stack-conf.json --from-file=finalcode.py -n adv-monstack
kubectl apply -f adv-monstack.yaml
