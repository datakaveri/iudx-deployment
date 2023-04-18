# Installation of Advance monitoring Stack

## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files.
3. Secrets directory after generation of secret files
```sh
secrets/
└── adv-mon-stack-conf.json
```
## Define Appropriate values of resources

- Define Appropriate nodeSelector value in the [`adv-monstack.yaml`](./adv-monstack.yaml)
- Define Appropriate nodeSelector value in the adv-monstack.yaml

## Deploy

Deploy advance monitoring stack

```sh
./install.sh
```
