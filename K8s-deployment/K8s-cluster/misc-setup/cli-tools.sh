#!/bin/bash

# kubectl cli bash  auto-completion

sudo apt install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
echo 'source <(kubectl completion bash)' >> ~/.bashrc

# helm bash completion

sudo helm completion bash > /etc/bash_completion.d/helm
