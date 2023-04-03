# argocd
# https://www.argocdtracing.io/

locals {
  argocd = merge(
    local.helm_defaults,
    {
      enabled    = false
      name       = "argocd"
      chart      = "${path.module}/charts/argocd"
      namespace  = "tools"
    },
    var.argocd
  )

  values_argocd = <<-VALUES
VALUES
}

resource "helm_release" "argocd" {
  count                 = local.argocd["enabled"] ? 1 : 0
  name                  = local.argocd["name"]
  chart                 = local.argocd["chart"]
  timeout               = local.argocd["timeout"]
  force_update          = local.argocd["force_update"]
  recreate_pods         = local.argocd["recreate_pods"]
  wait                  = local.argocd["wait"]
  atomic                = local.argocd["atomic"]
  cleanup_on_fail       = local.argocd["cleanup_on_fail"]
  dependency_update     = local.argocd["dependency_update"]
  render_subchart_notes = local.argocd["render_subchart_notes"]
  replace               = local.argocd["replace"]
  reset_values          = local.argocd["reset_values"]
  reuse_values          = local.argocd["reuse_values"]
  skip_crds             = local.argocd["skip_crds"]
  verify                = local.argocd["verify"]
  namespace             = local.argocd["namespace"]
  values                = [local.values_argocd, local.argocd["extra_values"]]
  depends_on            = [kubernetes_namespace.monitoring]
}
