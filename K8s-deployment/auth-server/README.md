# Install

## Creation of env file
Create env file named '.aaa.env' with following variables
```
AUTH_URL=https://authorizationtest.iudx.io
LOG_LEVEL=INFO
```

## Required secrets

```sh
secrets/
├── configs
│   └── config.json
├── keystore.jks
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
