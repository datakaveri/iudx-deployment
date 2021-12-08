# Install

## Creation of env file
Create env file named '.cat-api.env' with following variables
```
CAT_URL=https://api.catalogue.iudx.test.io
LOG_LEVEL=INFO
```

## Required secrets

```sh
secrets/
├── keystore.jks
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



