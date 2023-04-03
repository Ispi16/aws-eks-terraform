# Grafana
# https://docs.aws.amazon.com/eks/latest/userguide/grafana.html

locals {
  grafana = merge(
    local.helm_defaults,
    {
      enabled    = true
      name       = "grafana"
      chart      = "${path.module}/charts/grafana"
      namespace  = "monitoring"
    },
    var.grafana
  )

  values_grafana = <<-VALUES
# Administrator credentials when not using an existing secret (see below)
adminUser: admin
adminPassword: prom-operator
image:
  tag: "9.1.7"
persistence:
  enabled: true
  size: 8Gi
VALUES
}

resource "helm_release" "grafana" {
  count                 = local.grafana["enabled"] ? 1 : 0
  name                  = local.grafana["name"]
  chart                 = local.grafana["chart"]
  timeout               = local.grafana["timeout"]
  force_update          = local.grafana["force_update"]
  recreate_pods         = local.grafana["recreate_pods"]
  wait                  = local.grafana["wait"]
  atomic                = local.grafana["atomic"]
  cleanup_on_fail       = local.grafana["cleanup_on_fail"]
  dependency_update     = local.grafana["dependency_update"]
  render_subchart_notes = local.grafana["render_subchart_notes"]
  replace               = local.grafana["replace"]
  reset_values          = local.grafana["reset_values"]
  reuse_values          = local.grafana["reuse_values"]
  skip_crds             = local.grafana["skip_crds"]
  verify                = local.grafana["verify"]
  namespace             = local.grafana["namespace"]
  values                = [local.values_grafana, local.grafana["extra_values"]]
  depends_on            = [kubernetes_namespace.monitoring, helm_release.prometheus]
}
