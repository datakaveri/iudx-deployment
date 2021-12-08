# Install

## Creation of env file
Create env file named '.lip.env' with following variables
```
LIP_URL=none
LOG_LEVEL=INFO
```

## Required secrets

```sh
secrets/
├── attribute-mapping.json
└── one-verticle-configs
    ├── config-depl.json
    ├── config-processor.json
    ├── config-rabbitmq.json
    └── config-redis.json
```
## Deploy
Following install script deploys:
1. Verticle configs as secrets, environment
2. Deploys each verticle in seperate pod with HPA based on CPU
```sh
./install.sh
```
