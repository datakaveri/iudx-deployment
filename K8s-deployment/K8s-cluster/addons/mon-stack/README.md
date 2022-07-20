## Pre-Requisites
Secrets needed 
```
secrets/
├── admin-password (to set grafana admin Password)
├── admin-user    ( To set grafana admin username)
├── grafana-env-secret (Refer below for env vars to be set) 
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of requests and limits
- RAM of resuests and limits
- nodeSelector
- Storage class name
- cert-manager issuer and ingress hostname in grafana/resource-values.yaml

in `grafana/resource-values.yaml`, `loki/resource-values.yaml`, `prometheus/resource-values.yaml` and `promtail/resource-values.yaml` as shown in sample resource-values files present in the [`grafana/`](./grafana/),[`loki`](./loki/), [`prometheus/`](./prometheus/), and [`promtail/`](./promtail/) directories respectively.

## Deploy
1. To install the mon-stack
``` 
./install.sh 
```
This installs the whole mon-stack - prometheus, grafana, loki and promtail.

## Note
1.  Config Telegrambot for grafana's alerts is detailed [here](https://gist.github.com/abhilashvenkatesh/50478502ccd257a28d2c441ac51a8d65). Then appropiately define the environment file  secrets/grafana-env-secret. The template is defined as follow:
 Please do not include comments and substitute appropiate correct values in the placeholders ```<placholder>```.
```
GF_SERVER_ROOT_URL=https://<grafana-domain-name>/
GF_SERVER_DOMAIN=<grafana-domain-name>
TELEGRAM_CHAT_ID=<telegram-chat-id>
TELEGRAM_BOT_TOKEN=<telegram-chat-token>
```

