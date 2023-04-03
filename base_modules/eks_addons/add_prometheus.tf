# Prometheus
# https://docs.aws.amazon.com/eks/latest/userguide/prometheus.html

locals {
  prometheus = merge(
    local.helm_defaults,
    {
      enabled    = true
      name       = "prometheus"
      chart      = "${path.module}/charts/prometheus"
      namespace  = "monitoring"
    },
    var.prometheus
  )

  values_prometheus = <<-VALUES
alertmanager:
  enabled: false
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: node-role
          operator: In
          values:
          - monitoring
server:
  image:
    tag: v2.39.1
  persistentVolume:
    enabled: true
    size: 15Gi
  podAnnotations:
    sidecar.istio.io/inject: "true"
    sidecar.istio.io/rewriteAppHTTPProbers: "true"
    traffic.sidecar.istio.io/includeInboundPorts: ""   # do not intercept any inbound ports
    traffic.sidecar.istio.io/includeOutboundIPRanges: ""  # do not intercept any outbound traffic
    proxy.istio.io/config: |  # configure an env variable `OUTPUT_CERTS` to write certificates to the given folder
      proxyMetadata:
        OUTPUT_CERTS: /etc/istio-output-certs
    sidecar.istio.io/userVolumeMount: '[{"name": "istio-certs-dir", "mountPath": "/etc/istio-output-certs"}]' # mount the shared volume at sidecar proxy
  extraVolumeMounts:
    - name: istio-certs-dir
      mountPath: /etc/prom-certs/
  extraVolumes:
    - name: istio-certs-dir
      emptyDir:
        medium: Memory
kubeStateMetrics:
  extraArgs:
  - --labels-metric-allow-list="nodes=[*]"
extraScrapeConfigs: |
  - job_name: 'istio-mesh'
    kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - istio-system
    relabel_configs:
    - source_labels: [__meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
      action: keep
      regex: istio-telemetry;prometheus
  # Scrape config for envoy stats
  - job_name: 'envoy-stats'
    metrics_path: /stats/prometheus
    kubernetes_sd_configs:
    - role: pod
    relabel_configs:
    - source_labels: [__meta_kubernetes_pod_container_port_name]
      action: keep
      regex: '.*-envoy-prom'
    - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
      action: replace
      regex: ([^:]+)(?::\d+)?;(\d+)
      replacement: $1:15090
      target_label: __address__
    - action: labelmap
      regex: __meta_kubernetes_pod_label_(.+)
    - source_labels: [__meta_kubernetes_namespace]
      action: replace
      target_label: namespace
    - source_labels: [__meta_kubernetes_pod_name]
      action: replace
      target_label: pod_name
  - job_name: 'istio-policy'
    kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - istio-system
    relabel_configs:
    - source_labels: [__meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
      action: keep
      regex: istio-policy;http-monitoring
  - job_name: 'istio-telemetry'
    kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - istio-system
    relabel_configs:
    - source_labels: [__meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
      action: keep
      regex: istio-telemetry;http-monitoring
  - job_name: 'pilot'
    kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - istio-system
    relabel_configs:
    - source_labels: [__meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
      action: keep
      regex: istio-pilot;http-monitoring
  - job_name: 'galley'
    kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - istio-system
    relabel_configs:
    - source_labels: [__meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
      action: keep
      regex: istio-galley;http-monitoring
  - job_name: 'citadel'
    kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - istio-system
    relabel_configs:
    - source_labels: [__meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
      action: keep
      regex: istio-citadel;http-monitoring
  - job_name: 'kubernetes-pods-istio-secure'
    scheme: https
    tls_config:
      ca_file: /etc/prom-certs/root-cert.pem
      cert_file: /etc/prom-certs/cert-chain.pem
      key_file: /etc/prom-certs/key.pem
      insecure_skip_verify: true
    kubernetes_sd_configs:
    - role: pod
    relabel_configs:
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
      action: keep
      regex: true
    # sidecar status annotation is added by sidecar injector and
    # istio_workload_mtls_ability can be specifically placed on a pod to indicate its ability to receive mtls traffic.
    - source_labels: [__meta_kubernetes_pod_annotation_sidecar_istio_io_status, __meta_kubernetes_pod_annotation_istio_mtls]
      action: keep
      regex: (([^;]+);([^;]*))|(([^;]*);(true))
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scheme]
      action: drop
      regex: (http)
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
      action: replace
      target_label: __metrics_path__
      regex: (.+)
    - source_labels: [__address__]  # Only keep address that is host:port
      action: keep    # otherwise an extra target with ':443' is added for https scheme
      regex: ([^:]+):(\d+)
    - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
      action: replace
      regex: ([^:]+)(?::\d+)?;(\d+)
      replacement: $1:$2
      target_label: __address__
    - action: labelmap
      regex: __meta_kubernetes_pod_label_(.+)
    - source_labels: [__meta_kubernetes_namespace]
      action: replace
      target_label: namespace
    - source_labels: [__meta_kubernetes_pod_name]
      action: replace
      target_label: pod_name
VALUES
}

resource "helm_release" "prometheus" {
  count                 = local.prometheus["enabled"] ? 1 : 0
  name                  = local.prometheus["name"]
  chart                 = local.prometheus["chart"]
  timeout               = local.prometheus["timeout"]
  force_update          = local.prometheus["force_update"]
  recreate_pods         = local.prometheus["recreate_pods"]
  wait                  = local.prometheus["wait"]
  atomic                = local.prometheus["atomic"]
  cleanup_on_fail       = local.prometheus["cleanup_on_fail"]
  dependency_update     = local.prometheus["dependency_update"]
  render_subchart_notes = local.prometheus["render_subchart_notes"]
  replace               = local.prometheus["replace"]
  reset_values          = local.prometheus["reset_values"]
  reuse_values          = local.prometheus["reuse_values"]
  skip_crds             = local.prometheus["skip_crds"]
  verify                = local.prometheus["verify"]
  namespace             = local.prometheus["namespace"]
  values                = [local.values_prometheus, local.prometheus["extra_values"]]
  depends_on            = [kubernetes_namespace.monitoring]
}
