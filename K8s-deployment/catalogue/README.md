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
helm install cat-helm-test cat-helm-test/

## Parameters

### Global parameters

| Name                                 | Description                                          | Value                                         |
| ------------------------------------ | ---------------------------------------------------- | --------------------------------------------- |
| `namespace`                          | Namespace to deploy the controller                   | `cat`                                         |
| `image`                              | Docker Image                                         | `dockerhub.iudx.io/iudx/cat-prod:3.0-1cc8c35` |
| `imagePullSecrets`                   | Secret required to pull image                        | `regcred`                                     |
| `volumeConfigPath`                   | Path of secret config file                           | `/usr/share/app/secrets/one-verticle-configs` |
| `volumeSecretPath`                   | Path of keystore secret file                         | `/usr/share/app/secrets/`                     |
| `nodeSelector.enable`                | "true" to deploy on specifiv nodes                   | `false`                                       |
| `nodeSelector.selector`              | list selector in key-value pairs                     | `[]`                                          |
| `containerPorts.http.port`           | http port number                                     | `80`                                          |
| `containerPorts.http.protocol`       | http protocol                                        | `TCP`                                         |
| `containerPorts.hazelcast.port`      | hazelcast port number                                | `5701`                                        |
| `containerPorts.hazelcast.protocol`  | hazelcast protocol                                   | `TCP`                                         |
| `containerPorts.prometheus.port`     | prometheus port number                               | `9000`                                        |
| `containerPorts.prometheus.protocol` | prometheus protocol                                  | `TCP`                                         |
| `containerPorts.prometheus.scrape`   | To enable scraping                                   | `true`                                        |
| `livenessProbe.httpGet.path`         | Path for Liveness                                    | `/metrics`                                    |
| `livenessProbe.httpGet.port`         | Port for Liveness                                    | `9000`                                        |
| `configMapRef`                       | Name of configMap used in deployment                 | `cat-env`                                     |
| `env.fieldPath`                      | field from which environment variable gets its value | `status.podIP`                                |
| `initialDelaySeconds`                | Initial delay seconds for readinessProbe             | `60`                                          |
| `periodSeconds`                      | Period seconds for readinessProbe                    | `60`                                          |
| `timeoutSeconds`                     | Timeout seconds for readinessProbe                   | `10`                                          |


### Ingress parameters

| Name                          | Description                                | Value   |
| ----------------------------- | ------------------------------------------ | ------- |
| `ingress.enabled`             | To enable Ingress                          | `true`  |
| `ingress.rateLimitAnnotation` | To include RateLimit annotation to Ingress | `false` |
| `ingress.hosts`               | Host configuration to Ingress              | `nil`   |
| `ingress.tls`                 | Secret associated with Ingress             | `nil`   |


### Service parameters

| Name                 | Description                               | Value       |
| -------------------- | ----------------------------------------- | ----------- |
| `service.type`       | Type of service eg. nodePort or CLusterIp | `ClusterIP` |
| `service.port`       | Container Port                            | `80`        |
| `service.targetPort` | Service Port or Ttarget port              | `80`        |
| `service.selector`   | List of Selector                          | `[]`        |


### apiServer parameters

| Name                                                   | Description                              | Value                                                                                                                                                                                                                |
| ------------------------------------------------------ | ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `apiserver.replicas`                                   | Replicas for ApiServer Vertical          | `1`                                                                                                                                                                                                                  |
| `apiserver.autoscaling.enabled`                        | To enable autoscaling                    | `true`                                                                                                                                                                                                               |
| `apiserver.autoscaling.minReplicas`                    | Minimun Replicas                         | `1`                                                                                                                                                                                                                  |
| `apiserver.autoscaling.maxReplicas`                    | Max Replicas                             | `5`                                                                                                                                                                                                                  |
| `apiserver.autoscaling.targetCPUUtilizationPercentage` | Percentage for Target Cpu Utilization    | `80`                                                                                                                                                                                                                 |
| `apiserver.labels`                                     | Labels for ApiServer Verticles           | `[]`                                                                                                                                                                                                                 |
| `apiserver.limits`                                     | Limits Resource                          | `nil`                                                                                                                                                                                                                |
| `apiserver.requests`                                   | Resources Request Limit                  | `nil`                                                                                                                                                                                                                |
| `apiserver.command`                                    | Command to Execute specific to ApiServer | `["/bin/bash"]`                                                                                                                                                                                                      |
| `apiserver.args`                                       | Argument of Command                      | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-apiserver.json"]` |


### auditing parameters

| Name                                                  | Description                             | Value                                                                                                                                                                                                                |
| ----------------------------------------------------- | --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `auditing.replicas`                                   | Replicas for auditing Vertical          | `1`                                                                                                                                                                                                                  |
| `auditing.autoscaling.enabled`                        | To enable autoscaling                   | `true`                                                                                                                                                                                                               |
| `auditing.autoscaling.minReplicas`                    | Minimun Replicas                        | `1`                                                                                                                                                                                                                  |
| `auditing.autoscaling.maxReplicas`                    | Max Replicas                            | `5`                                                                                                                                                                                                                  |
| `auditing.autoscaling.targetCPUUtilizationPercentage` | Percentage for Target Cpu Utilization   | `80`                                                                                                                                                                                                                 |
| `auditing.labels`                                     | Labels for auditing Verticles           | `[]`                                                                                                                                                                                                                 |
| `auditing.limits`                                     | Limits Resource                         | `nil`                                                                                                                                                                                                                |
| `auditing.requests`                                   | Resources Request Limit                 | `nil`                                                                                                                                                                                                                |
| `auditing.command`                                    | Command to Execute specific to auditing | `["/bin/bash"]`                                                                                                                                                                                                      |
| `auditing.args`                                       | Argument of Command                     | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-auditing.json"]` |


### authenticator parameters

| Name                                                       | Description                                  | Value                                                                                                                                                                                                                     |
| ---------------------------------------------------------- | -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `authenticator.replicas`                                   | Replicas for authenticator Vertical          | `1`                                                                                                                                                                                                                       |
| `authenticator.autoscaling.enabled`                        | To enable autoscaling                        | `true`                                                                                                                                                                                                                    |
| `authenticator.autoscaling.minReplicas`                    | Minimun Replicas                             | `1`                                                                                                                                                                                                                       |
| `authenticator.autoscaling.maxReplicas`                    | Max Replicas                                 | `5`                                                                                                                                                                                                                       |
| `authenticator.autoscaling.targetCPUUtilizationPercentage` | Percentage for Target Cpu Utilization        | `80`                                                                                                                                                                                                                      |
| `authenticator.labels`                                     | Labels for authenticator Verticles           | `[]`                                                                                                                                                                                                                      |
| `authenticator.limits`                                     | Limits Resource                              | `nil`                                                                                                                                                                                                                     |
| `authenticator.requests`                                   | Resources Request Limit                      | `nil`                                                                                                                                                                                                                     |
| `authenticator.command`                                    | Command to Execute specific to authenticator | `["/bin/bash"]`                                                                                                                                                                                                           |
| `authenticator.args`                                       | Argument of Command                          | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-authenticator.json"]` |


### database parameters

| Name                                                  | Description                             | Value                                                                                                                                                                                                               |
| ----------------------------------------------------- | --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `database.replicas`                                   | Replicas for database Vertical          | `1`                                                                                                                                                                                                                 |
| `database.autoscaling.enabled`                        | To enable autoscaling                   | `true`                                                                                                                                                                                                              |
| `database.autoscaling.minReplicas`                    | Minimun Replicas                        | `1`                                                                                                                                                                                                                 |
| `database.autoscaling.maxReplicas`                    | Max Replicas                            | `5`                                                                                                                                                                                                                 |
| `database.autoscaling.targetCPUUtilizationPercentage` | Percentage for Target Cpu Utilization   | `80`                                                                                                                                                                                                                |
| `database.labels`                                     | Labels for database Verticles           | `[]`                                                                                                                                                                                                                |
| `database.limits`                                     | Limits Resource                         | `nil`                                                                                                                                                                                                               |
| `database.requests`                                   | Resources Request Limit                 | `nil`                                                                                                                                                                                                               |
| `database.command`                                    | Command to Execute specific to database | `["/bin/bash"]`                                                                                                                                                                                                     |
| `database.args`                                       | Argument of Command                     | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-database.json"]` |


### Validator parameters

| Name                                                   | Description                              | Value                                                                                                                                                                                                                   |
| ------------------------------------------------------ | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `validator.replicas`                                   | Replicas for validator Vertical          | `1`                                                                                                                                                                                                                     |
| `validator.autoscaling.enabled`                        | To enable autoscaling                    | `true`                                                                                                                                                                                                                  |
| `validator.autoscaling.minReplicas`                    | Minimun Replicas                         | `1`                                                                                                                                                                                                                     |
| `validator.autoscaling.maxReplicas`                    | Max Replicas                             | `5`                                                                                                                                                                                                                     |
| `validator.autoscaling.targetCPUUtilizationPercentage` | Percentage for Target Cpu Utilization    | `80`                                                                                                                                                                                                                    |
| `validator.labels`                                     | Labels for validator Verticles           | `[]`                                                                                                                                                                                                                    |
| `validator.limits`                                     | Limits Resource                          | `nil`                                                                                                                                                                                                                   |
| `validator.requests`                                   | Resources Request Limit                  | `nil`                                                                                                                                                                                                                   |
| `validator.command`                                    | Command to Execute specific to validator | `["/bin/bash"]`                                                                                                                                                                                                         |
| `validator.args`                                       | Argument of Command                      | `["-c","exec java  -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory   -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-validator.json"]` |



