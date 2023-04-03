# kafka

locals {
  kafka = merge(
    local.helm_defaults,
    {
      enabled   = false
      name      = "kafka"
      chart     = "${path.module}/charts/kafka"
      namespace = "tools"
    },
    var.kafka
  )

  values_kafka = <<-VALUES
VALUES
}

resource "helm_release" "kafka" {
  count                 = local.kafka["enabled"] ? 1 : 0
  name                  = local.kafka["name"]
  chart                 = local.kafka["chart"]
  timeout               = local.kafka["timeout"]
  force_update          = local.kafka["force_update"]
  recreate_pods         = local.kafka["recreate_pods"]
  wait                  = local.kafka["wait"]
  atomic                = local.kafka["atomic"]
  cleanup_on_fail       = local.kafka["cleanup_on_fail"]
  dependency_update     = local.kafka["dependency_update"]
  render_subchart_notes = local.kafka["render_subchart_notes"]
  replace               = local.kafka["replace"]
  reset_values          = local.kafka["reset_values"]
  reuse_values          = local.kafka["reuse_values"]
  skip_crds             = local.kafka["skip_crds"]
  verify                = local.kafka["verify"]
  namespace             = local.kafka["namespace"]
  values                = [local.values_kafka, local.kafka["extra_values"]]
  #depends_on            = [kubernetes_namespace.tools]
}
