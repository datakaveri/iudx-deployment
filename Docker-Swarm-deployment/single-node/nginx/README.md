# NGINX
## Project structure
```sh
.
|-- .env
|-- .gitignore
|-- README.md
|-- conf
|   `-- keycloak.conf
|-- nginx-stack.yml
`-- secrets
    |-- rs-cert
    `-- rs-key

```
## Node labels
On a docker-swarm master node, run
```sh
# Label the Resource Server NGINX node
docker node update --label-add nginx-node=true <hostname/ID>

```

