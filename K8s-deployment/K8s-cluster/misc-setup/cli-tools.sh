#!/bin/bash

sudo apt install -y bash-completion
source /usr/share/bash-completion/bash_completion

# kubectl install 
curl -LO "https://dl.k8s.io/release/$1/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$1/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# kubectl cli bash  auto-completion
sudo kubectl completion bash > /etc/bash_completion.d/kubectl

# helm install
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# helm bash completion
sudo helm completion bash > /etc/bash_completion.d/helm
