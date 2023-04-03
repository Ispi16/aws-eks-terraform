# kiali
# https://kiali.io/

locals {
  kiali = merge(
    local.helm_defaults,
    {
      enabled    = false
      name       = "kiali"
      chart      = "${path.module}/charts/kiali"
      namespace  = "monitoring"
    },
    var.kiali
  )

  values_kiali = <<-VALUES
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

resource "helm_release" "kiali" {
  count                 = local.kiali["enabled"] ? 1 : 0
  name                  = local.kiali["name"]
  chart                 = local.kiali["chart"]
  timeout               = local.kiali["timeout"]
  force_update          = local.kiali["force_update"]
  recreate_pods         = local.kiali["recreate_pods"]
  wait                  = local.kiali["wait"]
  atomic                = local.kiali["atomic"]
  cleanup_on_fail       = local.kiali["cleanup_on_fail"]
  dependency_update     = local.kiali["dependency_update"]
  render_subchart_notes = local.kiali["render_subchart_notes"]
  replace               = local.kiali["replace"]
  reset_values          = local.kiali["reset_values"]
  reuse_values          = local.kiali["reuse_values"]
  skip_crds             = local.kiali["skip_crds"]
  verify                = local.kiali["verify"]
  namespace             = local.kiali["namespace"]
  values                = [local.values_kiali, local.kiali["extra_values"]]
  depends_on            = [kubernetes_namespace.monitoring]
}
