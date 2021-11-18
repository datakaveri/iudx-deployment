# Install

## Required secrets

```sh
secrets/
├── one-verticle-configs
│   ├── config-apiserver.json
│   ├── config-auditing.json
│   ├── config-authenticator.json
│   ├── config-database.json
│   └── config-validator.json
└── pki
    ├── fullchain.pem
    └── privkey.pem
```
## Deploy
Following install script deploys:
1. Verticle configs as secrets, environment
2. Deploys each verticle in seperate pod with HPA based on CPU
```sh
./install.sh
```

helm install cat-helm cat-helm-mini/
