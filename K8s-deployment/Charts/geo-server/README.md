
## Introduction

Helm Chart for IUDX Geoserver Server Deployment

## Create secret files

1. Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.geoserver.env file with appropriate values in the place holders “<>”.
3. Following config options are only need to be configured if its deployed as geoserver, or else it can
   be left as is :
```
      "keycloakServerHost": "https://{{keycloak-domain}}/auth/realms/demo",
      "certsEndpoint": "/protocol/openid-connect/certs"
```

```
# secrets directory after generation of secret files
secrets/
├── .geoserver.env
└── config.json
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all geoserver verticles
- RAM of all geoserver verticles
- ingress.hostname
- cert-manager issuer

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `geoserver`chart:

```console
 ./install.sh
```

The command deploys  geoserver on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `geoserver`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all geoserver verticles 

## Uninstalling the Chart

To uninstall/delete the `geoserver` deployment:

```console
 helm delete geoserver
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
| `image.repository`          | image repository                           | `iudx/geoserver-dev`     |
| `image.tag`                 | image tag (immutable tags are recommended) | `1.0.0-alpha-534c332`       |
| `image.pullPolicy`          | image pull policy                          | `IfNotPresent`      |
| `image.pullSecrets`         | image pull secrets                         | `["regcred"]`       |
| `image.debug`               | Enable image debug mode                    | `false`             |
| `containerPorts.http`       | HTTP container port                        | `80`                |
| `containerPorts.https`      | HTTPS container port                       | `443`               |
| `containerPorts.hazelcast`  | Hazelcast container port                   | `5701`              |
| `containerPorts.prometheus` | Prometheus container port                  | `9000`              |
| `podAnnotations`            | Annotations for pods                       | `nil`               |


### ApiServer Parameters

| Name                                             | Description                                                                                        | Value                                                                                                                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `geoserver.enabled`                          | Enable geoserver Verticle for deployment                                                              | `true`
| `geoserver.replicaCount`                          | Number of geoserver replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `geoserver.livenessProbe.enabled`                 | Enable livenessProbe on geoserver containers                                                        | `true`                                                                                                                                                                                                               |
| `geoserver.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                            | `60`                                                                                                                                                                                                                 |
| `geoserver.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                   | `60`                                                                                                                                                                                                                 |
| `geoserver.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `geoserver.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `geoserver.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `geoserver.livenessProbe.path`                    | Path for httpGet                                                                                   | `/metrics`                                                                                                                                                                                                           |
| `geoserver.readinessProbe.enabled`                | Enable readinessProbe on geoserver containers                                                       | `false`                                                                                                                                                                                                              |
| `geoserver.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                           | `10`                                                                                                                                                                                                                 |
| `geoserver.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `geoserver.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `geoserver.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `geoserver.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `geoserver.startupProbe.enabled`                  | Enable startupProbe on geoserver containers                                                         | `false`                                                                                                                                                                                                              |
| `geoserver.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                             | `10`                                                                                                                                                                                                                 |
| `geoserver.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `geoserver.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `geoserver.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `geoserver.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `geoserver.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `geoserver.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                               | `{}`                                                                                                                                                                                                                 |
| `geoserver.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `geoserver.resources.limits`                      | The resources limits for the geoserver containers                                                   | `nil`                                                                                                                                                                                                                |
| `geoserver.resources.requests`                    | The requested resources for the geoserver containers                                                | `nil`                                                                                                                                                                                                                |
| `geoserver.podSecurityContext.enabled`            | Enabled geoserver pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `geoserver.podSecurityContext.fsGroup`            | Set geoserver pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `geoserver.containerSecurityContext.enabled`      | Enabled geoserver containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `geoserver.containerSecurityContext.runAsUser`    | Set geoserver containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `geoserver.containerSecurityContext.runAsNonRoot` | Set geoserver containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `geoserver.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for geoserver                      | `nil`                                                                                                                                                                                                                |
| `geoserver.command`                               | Override default container command (useful when using custom images)                               | `["/bin/bash"]`                                                                                                                                                                                                      |
| `geoserver.args`                                  | Override default container args (useful when using custom images)                                  | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-geoserver.json"]` |
| `geoserver.hostAliases`                           | geoserver pods host aliases                                                                         | `[]`                                                                                                                                                                                                                 |
| `geoserver.podLabels`                             | Extra labels for geoserver pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `geoserver.podAffinityPreset`                     | Pod affinity preset. Ignored if `geoserver.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `geoserver.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `geoserver.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `geoserver.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `geoserver.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `geoserver.nodeAffinityPreset.key`                | Node label key to match. Ignored if `geoserver.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `geoserver.nodeAffinityPreset.values`             | Node label values to match. Ignored if `geoserver.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
| `geoserver.affinity`                              | Affinity for geoserver pods assignment                                                              | `{}`                                                                                                                                                                                                                 |
| `geoserver.nodeSelector`                          | Node labels for geoserver pods assignment                                                           | `nil`                                                                                                                                                                                                                |
| `geoserver.tolerations`                           | Tolerations for geoserver pods assignment                                                           | `[]`                                                                                                                                                                                                                 |
| `geoserver.updateStrategy.type`                   | geoserver statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                      |
| `geoserver.priorityClassName`                     | geoserver pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                 |
| `geoserver.schedulerName`                         | Name of the k8s scheduler (other than default) for geoserver pods                                   | `""`                                                                                                                                                                                                                 |
| `geoserver.lifecycleHooks`                        | for the geoserver container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                 |
| `geoserver.extraEnvVars`                          | Array with extra environment variables to add to geoserver nodes                                    | `[]`                                                                                                                                                                                                                 |
| `geoserver.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for geoserver nodes                            | `geoserver-env`                                                                                                                                                                                                            |
| `geoserver.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for geoserver nodes                               | `nil`                                                                                                                                                                                                                |
| `geoserver.extraVolumes`                          | Optionally specify extra list of additional volumes for the geoserver pod(s)                        | `nil`                                                                                                                                                                                                                |
| `geoserver.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the geoserver container(s)             | `nil`                                                                                                                                                                                                                |
| `geoserver.sidecars`                              | Add additional sidecar containers to the geoserver pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `geoserver.initContainers`                        | Add additional init containers to the geoserver pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `geoserver.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                       | `true`                                                                                                                                                                                                               |
| `geoserver.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                  | `1`                                                                                                                                                                                                                  |
| `geoserver.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                  | `5`                                                                                                                                                                                                                  |
| `geoserver.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                  | `80`                                                                                                                                                                                                                 |
| `geoserver.autoscaling.targetMemory`              | Target Memory utilization percentage                                                               | `nil`                                                                                                                                                                                                                |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | ApiServers ervice type                                                                                                           | `ClusterIP`              |
| `service.ports`                    | ApiServer service port                                                                                                           | `80`                     |
| `service.targetPorts`              | ApiServer service TargetPorts port                                                                                               | `80`                     |
| `service.clusterIP`                | ApiServer service Cluster IP                                                                                                     | `nil`                    |
| `service.loadBalancerIP`           | ApiServer service Load Balancer IP                                                                                               | `nil`                    |
| `service.loadBalancerSourceRanges` | service Load Balancer sources                                                                                                    | `[]`                     |
| `service.externalTrafficPolicy`    | service external traffic policy                                                                                                  | `Cluster`                |
| `service.annotations`              | Additional custom annotations for service                                                                                        | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in service (normally used with the `sidecars` value)                                                       | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for %%MAIN_CONTAINER_NAME%%                                                                     | `true`                   |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `nil`                    |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `geoserver.test.io`            |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.serviceName`              | Backend ingress Service Name                                                                                                     | `geoserver`         |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `nil`                    |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |


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
 helm install geoserver geoserver \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install geoserver -f values.yaml geoserver/
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

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).


