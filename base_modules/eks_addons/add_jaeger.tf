# jaeger
# https://www.jaegertracing.io/

locals {
  jaeger = merge(
    local.helm_defaults,
    {
      enabled    = false
      name       = "jaeger"
      chart      = "${path.module}/charts/jaeger"
      namespace  = "monitoring"
    },
    var.jaeger
  )

  values_jaeger = <<-VALUES
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: node-role
          operator: In
          values:
          - monitoring
VALUES
}

resource "helm_release" "jaeger" {
  count                 = local.jaeger["enabled"] ? 1 : 0
  name                  = local.jaeger["name"]
  chart                 = local.jaeger["chart"]
  timeout               = local.jaeger["timeout"]
  force_update          = local.jaeger["force_update"]
  recreate_pods         = local.jaeger["recreate_pods"]
  wait                  = local.jaeger["wait"]
  atomic                = local.jaeger["atomic"]
  cleanup_on_fail       = local.jaeger["cleanup_on_fail"]
  dependency_update     = local.jaeger["dependency_update"]
  render_subchart_notes = local.jaeger["render_subchart_notes"]
  replace               = local.jaeger["replace"]
  reset_values          = local.jaeger["reset_values"]
  reuse_values          = local.jaeger["reuse_values"]
  skip_crds             = local.jaeger["skip_crds"]
  verify                = local.jaeger["verify"]
  namespace             = local.jaeger["namespace"]
  values                = [local.values_jaeger, local.jaeger["extra_values"]]
  depends_on            = [kubernetes_namespace.monitoring]
}
