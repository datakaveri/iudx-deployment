# Install

## Creation of env file
Create env file named '.rs-api.env' with following variables
```
RS_URL=https://rs.test.iudx.io
LOG_LEVEL=INFO
```

## Required secrets

```sh
secrets/
├── keystore.jks
├── one-verticle-configs
│   ├── config-apiserver.json
│   ├── config-archives-database.json
│   ├── config-authenticator.json
│   ├── config-databroker.json
│   ├── config-latest-database.json
│   └── config-metering.json
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

