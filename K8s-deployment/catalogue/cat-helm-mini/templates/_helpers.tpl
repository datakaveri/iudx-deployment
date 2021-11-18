{{/*
Expand the name of the chart.
*/}}
{{- define "cath.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cath.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cath.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cath.labels" -}}
helm.sh/chart: {{ include "cath.chart" . }}
{{ include "cath.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cath.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cath.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cath.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cath.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "math.annotation" -}}
prometheus.io/port: {{ .Values.containerPorts.prometheus.port | quote }}
prometheus.io/scrape: {{ .Values.containerPorts.prometheus.scrape | quote }}
{{- end }}

{{- define "math.livenessProbe.httpGet" -}}
path: {{ .Values.livenessProbe.httpGet.path}} 
port: {{ .Values.livenessProbe.httpGet.port}} 
{{- end }}


{{- define "math.env.myPodIp" -}}
valueFrom:
  fieldRef:
    fieldPath: {{ .Values.env.fieldPath }}
{{- end }}

{{- define "math.apiserver.service" -}}
{{- range $str := .Values.apiserver.service.selector }}
{{ $str }}
{{- end }}
{{- end }}
