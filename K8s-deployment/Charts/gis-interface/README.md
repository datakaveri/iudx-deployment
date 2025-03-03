[![Kubescape Status](https://img.shields.io/jenkins/build?jobUrl=https%3A%2F%2Fjenkins.iudx.io%2Fjob%2Fkubescape-gis%2F&label=Kubescape)](https://jenkins.iudx.io/job/kubescape-gis/lastBuild/Kubescape_20Scan_20Report_20for_20GIS/)

## Introduction

Helm Chart for IUDX GIS Interface Deployment

## Create secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/* .
```

```
# secrets directory after generation of secret files
secrets/
├── .gis-api.env
└── config.json
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all gis-interface verticles
- RAM of all gis-interface verticles
- ingress.hostname
- cert-manager issuer

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `gis-interface`chart:

```console
 ./install.sh  --set ingress.hostname=<gis-hostname>
```

The command deploys  resource-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `gis`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all gis-interface verticles 

### To create ingress redirect to cos url:
```console
kubectl apply -f ../../misc/redirect-gis-ingress.yaml -n gis
```

## Uninstalling the Chart

To uninstall/delete the `gis-interface` deployment:

```console
 helm delete gis-interface -n gis
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

| Name                        | Description                                                   | Value                |
| --------------------------- | ------------------------------------------------------------- | -------------------- |
| `image.registry`            | gis-interface image registry                             | `ghcr.io`            |
| `image.repository`          | gis-interface image repository                           | `datakaveri/gis-depl` |
| `image.tag`                 | gis-interface image tag (immutable tags are recommended) | `3.0-fc10a3a`        |
| `image.pullPolicy`          | gis-interface image pull policy                          | `IfNotPresent`       |
| `image.pullSecrets`         | gis-interface image pull secrets                         | `nil`                |
| `image.debug`               | Enable gis-interface image debug mode                    | `false`              |
| `containerPorts.http`       | HTTP container port                                           | `80`                 |
| `containerPorts.hazelcast`  | Hazelcast container port                                      | `5701`               |
| `containerPorts.prometheus` | Prometheus container port                                     | `9000`               |
| `podAnnotations`            | Annotations for pods                                          | `nil`                |


### GIS-Interface Server Parameters

| Name                                              | Description                                                                                         | Value                                                                                                                                                                                                                |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `gisInterface.replicaCount`                          | Number of gisInterface replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `gisInterface.livenessProbe.enabled`                 | Enable livenessProbe on gisInterface containers                                                        | `true`                                                                                                                                                                                                               |
| `gisInterface.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                             | `60`                                                                                                                                                                                                                 |
| `gisInterface.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                    | `60`                                                                                                                                                                                                                 |
| `gisInterface.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `gisInterface.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `gisInterface.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `gisInterface.livenessProbe.path`                    | Path for httpGet                                                                                    | `/metrics`                                                                                                                                                                                                           |
| `gisInterface.readinessProbe.enabled`                | Enable readinessProbe on gisInterface containers                                                       | `false`                                                                                                                                                                                                              |
| `gisInterface.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                            | `10`                                                                                                                                                                                                                 |
| `gisInterface.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `gisInterface.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `gisInterface.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `gisInterface.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `gisInterface.startupProbe.enabled`                  | Enable startupProbe on gisInterface containers                                                         | `false`                                                                                                                                                                                                              |
| `gisInterface.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                              | `10`                                                                                                                                                                                                                 |
| `gisInterface.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                     | `10`                                                                                                                                                                                                                 |
| `gisInterface.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `gisInterface.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `gisInterface.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `gisInterface.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `gisInterface.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `gisInterface.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                  | `{}`                                                                                                                                                                                                                 |
| `gisInterface.resources.limits`                      | The resources limits for the gisInterface containers                                                   | `nil`                                                                                                                                                                                                                |
| `gisInterface.resources.requests`                    | The requested resources for the gisInterface containers                                                | `nil`                                                                                                                                                                                                                |
| `gisInterface.podSecurityContext.enabled`            | Enabled gisInterface pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `gisInterface.podSecurityContext.fsGroup`            | Set gisInterface pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `gisInterface.containerSecurityContext.enabled`      | Enabled gisInterface containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `gisInterface.containerSecurityContext.runAsUser`    | Set gisInterface containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `gisInterface.containerSecurityContext.runAsNonRoot` | Set gisInterface containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `gisInterface.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for gisInterface                      | `nil`                                                                                                                                                                                                                |
| `gisInterface.command`                               | Override default container command (useful when using custom images)                                | `["/bin/bash"]`                                                                                                                                                                                                      |
| `gisInterface.args`                                  | Override default container args (useful when using custom images)                                   | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-apiserver.json"]` |
| `gisInterface.hostAliases`                           | gisInterface pods host aliases                                                                         | `[]`                                                                                                                                                                                                                 |
| `gisInterface.podLabels`                             | Extra labels for gisInterface pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `gisInterface.podAffinityPreset`                     | Pod affinity preset. Ignored if `gisInterface.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `gisInterface.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `gisInterface.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `gisInterface.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `gisInterface.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `gisInterface.nodeAffinityPreset.key`                | Node label key to match. Ignored if `gisInterface.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `gisInterface.nodeAffinityPreset.values`             | Node label values to match. Ignored if `gisInterface.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
| `gisInterface.affinity`                              | Affinity for gisInterface pods assignment                                                              | `{}`                                                                                                                                                                                                                 |
| `gisInterface.nodeSelector`                          | Node labels for gisInterface pods assignment                                                           | `nil`                                                                                                                                                                                                                |
| `gisInterface.tolerations`                           | Tolerations for gisInterface pods assignment                                                           | `[]`                                                                                                                                                                                                                 |
| `gisInterface.updateStrategy.type`                   | gisInterface statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                      |
| `gisInterface.priorityClassName`                     | gisInterface pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                 |
| `gisInterface.schedulerName`                         | Name of the k8s scheduler (other than default) for gisInterface pods                                   | `""`                                                                                                                                                                                                                 |
| `gisInterface.lifecycleHooks`                        | for the gisInterface container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                 |
| `gisInterface.extraEnvVars`                          | Array with extra environment variables to add to gisInterface nodes                                    | `[]`                                                                                                                                                                                                                 |
| `gisInterface.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for gisInterface nodes                            | `gis-env`                                                                                                                                                                                                             |
| `gisInterface.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for gisInterface nodes                               | `nil`                                                                                                                                                                                                                |
| `gisInterface.extraVolumes`                          | Optionally specify extra list of additional volumes for the gisInterface pod(s)                        | `nil`                                                                                                                                                                                                                |
| `gisInterface.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the gisInterface container(s)             | `nil`                                                                                                                                                                                                                |
| `gisInterface.sidecars`                              | Add additional sidecar containers to the gisInterface pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `gisInterface.initContainers`                        | Add additional init containers to the gisInterface pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `gisInterface.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                        | `true`                                                                                                                                                                                                               |
| `gisInterface.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                   | `1`                                                                                                                                                                                                                  |
| `gisInterface.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                   | `7`                                                                                                                                                                                                                  |
| `gisInterface.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                   | `80`                                                                                                                                                                                                                 |
| `gisInterface.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                | `nil`                                                                                                                                                                                                                |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | ApiServers ervice type                                                                                                           | `ClusterIP`              |
| `service.ports`                    | ApiServer service port                                                                                                           | `80`                     |
| `service.targetPorts`              | ApiServer service TargetPorts port                                                                                               | `80`                     |
| `service.clusterIP`                | ApiServer service Cluster IP                                                                                                     | `nil`                    |
| `service.loadBalancerIP`           | gisInterface service Load Balancer IP                                                                                               | `nil`                    |
| `service.loadBalancerSourceRanges` | gisInterface service Load Balancer sources                                                                                          | `[]`                     |
| `service.externalTrafficPolicy`    | gisInterface service external traffic policy                                                                                        | `Cluster`                |
| `service.annotations`              | Additional custom annotations for gisInterface service                                                                              | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in gisInterface service (normally used with the `sidecars` value)                                             | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for gisInterface                                                                                   | `true`                   |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `nil`                    |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `di.iudx.org.in`         |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.serviceName`              | Backend ingress Service Name                                                                                                     | `gis-api-server`          |
| `ingress.tls.secretName`                      | TLS secret name, if certmanager is used, no need to create that secret with tls certificates else create secret using the command `kubectl create secret tls gis-tls-secret --key ./secrets/pki/privkey.pem --cert ./secrets/pki/fullchain.pem -n gis`                                                    | `gis-tls-secret`                    |
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
| `serviceAccount.create` | Specifies whether a ServiceAccount should be created | `false` |
| `serviceAccount.name`   | The name of the ServiceAccount to use.               | `""`    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install gis-interface gis-interface \  -n gis
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install gis-interface -f values.yaml gis-interface/ -n gis
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

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters

## Troubleshooting

Find more information about how to deal with common errors related to Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
