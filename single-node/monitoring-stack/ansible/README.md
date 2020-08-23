# Ansible
## Ad-hocs
### Manage node exporters
```sh
# Install node exporter
ansible cluster -i inventory.yml -m script -a "scripts/node-exporter-manager.sh -a install"

# Unnstall node exporter
ansible cluster -i inventory.yml -m script -a "scripts/node-exporter-manager.sh -a uninstall"

# Start node exporter
ansible cluster -i inventory.yml -m script -a "scripts/node-exporter-manager.sh -a start"

# Stop node exporter
ansible cluster -i inventory.yml -m script -a "scripts/node-exporter-manager.sh -a stop"

# Check status
ansible cluster -i inventory.yml -m script -a "scripts/node-exporter-manager.sh -a status"
```
## Playbooks
### metrics-target-update
* Updates `/tmp/metrics-targets/node-exporter.json` on all manager nodes with node-exporter targets from inventory group `nodes-with-exporter`
* Updates `/tmp/metrics-targets/docker.json` on all manager nodes with node-exporter targets from inventory group `nodes-with-docker`

## Template Inventory
```yml
all:
  hosts:
    ...
  children:
    managers:
      ...
    cluster:
      ...
    nodes-with-docker:
      hosts:
        ...
      vars:
        docker_metrics_port: 9323

    nodes-with-exporter:
      hosts:
        ...
      vars:
        exporter_metrics_port: 9100
```