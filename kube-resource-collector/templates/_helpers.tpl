{{- define "k8-inspector.labels" -}}
app: k8-inspector
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
release: {{ .Release.Name }}
{{- end }}
