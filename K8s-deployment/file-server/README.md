# Install

## Creation of env file
Create env file named '.file-server.env' with following variables

```
FS_URL=https://file.iudx.test.io
LOG_LEVEL=INFO
```

## Required secrets

```sh
secrets/
├── keystore-file.jks
├── keystore-rs.jks
├── one-verticle-configs
│   ├── config-apiserver.json
│   ├── config-authenticator.json
│   └── config-database.json
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
