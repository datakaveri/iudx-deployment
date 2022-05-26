{{/*
Return the proper %%MAIN_OBJECT_BLOCK%% image name
*/}}
{{- define "immudb.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}


{{/*
Return the proper hook image name
*/}}
{{- define "immudbHook.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.immudb.install.hookImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "immudb.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "immudb.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image  .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "immudb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
*/}}
{{- define "immudb.ingress.certManagerRequest" -}}
{{ if or (hasKey . "cert-manager.io/cluster-issuer") (hasKey . "cert-manager.io/issuer") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "immudb.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "immudb.apiServer.validateValues.foo" .) -}}
{{- $messages := append $messages (include "immudb.apiServer.validateValues.bar" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Storage Class
Usage:
{{ include "fileServer.storageClass" (dict "global" .Values.global "local" .Values.master) }}
*/}}
{{- define "immudb.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .global -}}
    {{- if .global.storageClass -}}
        {{- if (eq "-" .global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .local.persistence.storageClass -}}
              {{- if (eq "-" .local.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .local.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .local.persistence.storageClass -}}
        {{- if (eq "-" .local.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .local.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}