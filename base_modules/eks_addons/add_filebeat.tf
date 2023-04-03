# Filebeat filebeat with Elasticsearch and Kibana
# https://www.elastic.co/beats/filebeat

locals {
  filebeat = merge(
    local.helm_defaults,
    {
      enabled   = true
      name      = "filebeat"
      chart     = "${path.module}/charts/filebeat"
      namespace = "monitoring"
    },
    var.filebeat
  )

  values_filebeat = <<-VALUES
environment: dev
namespace: monitoring
hosts: '["https://elastic.com:9200"]'
username: 'elastic'
password: 'password'
filebeatConfig:
    filebeat.yml: |
      filebeat.inputs:
      - type: container
        paths:
          - /var/log/containers/*app*.log
        exclude_files:
          - .*istio.*
        processors:
        - add_cloud_metadata:
        - add_host_metadata:
        - add_kubernetes_metadata:
            host: $NODE_NAME
            namespace: apps
            matchers:
            - logs_path:
                logs_path: "/var/log/containers/"
        fields:
          index: apps-logs
        json.keys_under_root: true
        json.add_error_key: true
VALUES
}

resource "helm_release" "filebeat" {
  count                 = local.filebeat["enabled"] ? 1 : 0
  name                  = local.filebeat["name"]
  chart                 = local.filebeat["chart"]
  timeout               = local.filebeat["timeout"]
  force_update          = local.filebeat["force_update"]
  recreate_pods         = local.filebeat["recreate_pods"]
  wait                  = local.filebeat["wait"]
  atomic                = local.filebeat["atomic"]
  cleanup_on_fail       = local.filebeat["cleanup_on_fail"]
  dependency_update     = local.filebeat["dependency_update"]
  render_subchart_notes = local.filebeat["render_subchart_notes"]
  replace               = local.filebeat["replace"]
  reset_values          = local.filebeat["reset_values"]
  reuse_values          = local.filebeat["reuse_values"]
  skip_crds             = local.filebeat["skip_crds"]
  verify                = local.filebeat["verify"]
  namespace             = local.filebeat["namespace"]
  values                = [local.values_filebeat, local.filebeat["extra_values"]]
  depends_on            = [kubernetes_namespace.monitoring]
}
