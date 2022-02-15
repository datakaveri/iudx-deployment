#!/bin/bash -x
sudo apt update && sudo apt upgrade -y
cat <<EOF > /etc/sysctl.d/90-kubelet.conf
vm.overcommit_memory = 1
vm.panic_on_oom = 0
kernel.panic = 10
kernel.panic_on_oops = 1
kernel.keys.root_maxkeys = 1000000
kernel.keys.root_maxbytes = 25000000
EOF
  
sysctl -p /etc/sysctl.d/90-kubelet.conf

curl -sL https://releases.rancher.com/install-docker/19.03.sh | sh
sudo usermod -aG docker ubuntu

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: ${TOKEN}" -s http://169.254.169.254/latest/meta-data/local-ipv4)
K8S_ROLES="--etcd --controlplane"

sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run  rancher/rancher-agent:v2.5.9 --server https://<rancher_server_url> --token <token-value> --ca-checksum <ca_checksum_value-optional>  --internal-address $PRIVATE_IP $K8S_ROLES
