## Introduction

Helm Chart for IUDX dmpapd Server Deployment

## Create secret files

1. Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.dmpapd.env file with appropriate values in the place holders “<>”.
3. Following config options are only need to be configured if its deployed as UAC dmpapd, or else it can
   be left as is :
```
      "keycloakServerHost": "https://{{keycloak-domain}}/auth/realms/demo",
      "certsEndpoint": "/protocol/openid-connect/certs"
```

```
# secrets directory after generation of secret files
secrets/
├── .dmpapd.env
└── config.json
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all dmpapd-server verticles
- RAM of all dmpapd-server verticles
- ingress.hostname
- cert-manager issuer

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `dmpapd-server`chart:

```console
 ./install.sh
```

The command deploys  dmpapd-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `dmp-apd`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all dmpapd-server verticles 



## Uninstalling the Chart

To uninstall/delete the `dmpapd` deployment:

```console
 helm delete dmpapd
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |


### Image Parameters

| Name                        | Description                                | Value               |
| --------------------------- | ------------------------------------------ | ------------------- |
| `image.registry`            | image registry                             | `dockerhub.iudx.io` |
| `image.repository`          | image repository                           | `iudx/dmpapd-prod`     |
| `image.tag`                 | image tag (immutable tags are recommended) | `3.0-1cc8c35`       |
| `image.pullPolicy`          | image pull policy                          | `IfNotPresent`      |
| `image.pullSecrets`         | image pull secrets                         | `["regcred"]`       |
| `image.debug`               | Enable image debug mode                    | `false`             |
| `containerPorts.http`       | HTTP container port                        | `80`                |
| `containerPorts.https`      | HTTPS container port                       | `443`               |
| `containerPorts.hazelcast`  | Hazelcast container port                   | `5701`              |
| `containerPorts.prometheus` | Prometheus container port                  | `9000`              |
| `podAnnotations`            | Annotations for pods                       | `nil`               |


### dmpapd Parameters

| Name                                             | Description                                                                                        | Value                                                                                                                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `dmpapd.enabled`                          | Enable dmpapd Verticle for deployment                                                              | `true`
| `dmpapd.replicaCount`                          | Number of dmpapd replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `dmpapd.livenessProbe.enabled`                 | Enable livenessProbe on dmpapd containers                                                        | `true`                                                                                                                                                                                                               |
| `dmpapd.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                            | `60`                                                                                                                                                                                                                 |
| `dmpapd.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                   | `60`                                                                                                                                                                                                                 |
| `dmpapd.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `dmpapd.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `dmpapd.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `dmpapd.livenessProbe.path`                    | Path for httpGet                                                                                   | `/metrics`                                                                                                                                                                                                           |
| `dmpapd.readinessProbe.enabled`                | Enable readinessProbe on dmpapd containers                                                       | `false`                                                                                                                                                                                                              |
| `dmpapd.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                           | `10`                                                                                                                                                                                                                 |
| `dmpapd.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `dmpapd.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `dmpapd.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `dmpapd.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `dmpapd.startupProbe.enabled`                  | Enable startupProbe on dmpapd containers                                                         | `false`                                                                                                                                                                                                              |
| `dmpapd.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                             | `10`                                                                                                                                                                                                                 |
| `dmpapd.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `dmpapd.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `dmpapd.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `dmpapd.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `dmpapd.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `dmpapd.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                               | `{}`                                                                                                                                                                                                                 |
| `dmpapd.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `dmpapd.resources.limits`                      | The resources limits for the dmpapd containers                                                   | `nil`                                                                                                                                                                                                                |
| `dmpapd.resources.requests`                    | The requested resources for the dmpapd containers                                                | `nil`                                                                                                                                                                                                                |
| `dmpapd.podSecurityContext.enabled`            | Enabled dmpapd pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `dmpapd.podSecurityContext.fsGroup`            | Set dmpapd pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `dmpapd.containerSecurityContext.enabled`      | Enabled dmpapd containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `dmpapd.containerSecurityContext.runAsUser`    | Set dmpapd containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `dmpapd.containerSecurityContext.runAsNonRoot` | Set dmpapd containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `dmpapd.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for dmpapd                      | `nil`                                                                                                                                                                                                                |
| `dmpapd.command`                               | Override default container command (useful when using custom images)                               | `["/bin/bash"]`                                                                                                                                                                                                      |
| `dmpapd.args`                                  | Override default container args (useful when using custom images)                                  | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-dmpapd.json"]` |
| `dmpapd.hostAliases`                           | dmpapd pods host aliases                                                                         | `[]`                                                                                                                                                                                                                 |
| `dmpapd.podLabels`                             | Extra labels for dmpapd pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `dmpapd.podAffinityPreset`                     | Pod affinity preset. Ignored if `dmpapd.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `dmpapd.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `dmpapd.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `dmpapd.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `dmpapd.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `dmpapd.nodeAffinityPreset.key`                | Node label key to match. Ignored if `dmpapd.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `dmpapd.nodeAffinityPreset.values`             | Node label values to match. Ignored if `dmpapd.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
                                                                                                          |



### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | dmpapds ervice type                                                                                                           | `ClusterIP`              |
| `service.ports`                    | dmpapd service port                                                                                                           | `80`                     |
| `service.targetPorts`              | dmpapd service TargetPorts port                                                                                               | `80`                     |
| `service.clusterIP`                | dmpapd service Cluster IP                                                                                                     | `nil`                    |
| `service.loadBalancerIP`           | dmpapd service Load Balancer IP                                                                                               | `nil`                    |
| `service.loadBalancerSourceRanges` | service Load Balancer sources                                                                                                    | `[]`                     |
| `service.externalTrafficPolicy`    | service external traffic policy                                                                                                  | `Cluster`                |
| `service.annotations`              | Additional custom annotations for service                                                                                        | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in service (normally used with the `sidecars` value)                                                       | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for %%MAIN_CONTAINER_NAME%%                                                                     | `true`                   |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `nil`                    |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `dmpapd.test.io`            |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certifidmpapde autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.serviceName`              | Backend ingress Service Name                                                                                                     | `dmpapd-api-server`         |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `nil`                    |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certifidmpapdes generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certifidmpapdes as secrets                                                                                               | `[]`                     |


### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                              |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ---------------------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                            |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`                        |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell`            |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `10-debian-10-r%%IMAGE_REVISION%%` |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `IfNotPresent`                     |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `[]`                               |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                               |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                               |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                                |


### Other Parameters

| Name                    | Description                                          | Value   |
| ----------------------- | ---------------------------------------------------- | ------- |
| `rbac.create`           | Specifies whether RBAC resources should be created   | `false` |
| `serviceAccount.create` | Specifies whether a ServiceAccount should be created | `false` |
| `serviceAccount.name`   | The name of the ServiceAccount to use.               | `""`    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
 helm install dmpapd dmpapd \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install dmpapd -f values.yaml dmpapd/
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.


### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specifidmpapdion of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).


