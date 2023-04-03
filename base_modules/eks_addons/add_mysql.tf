# mysql

locals {
  mysql = merge(
    local.helm_defaults,
    {
      enabled   = false
      name      = "mysql"
      chart     = "${path.module}/charts/mysql"
      namespace = "tools"
    },
    var.mysql
  )

  values_mysql = <<-VALUES
auth:
    rootPassword: "password"
    database: "appdatabase"
VALUES
}

resource "helm_release" "mysql" {
  count                 = local.mysql["enabled"] ? 1 : 0
  name                  = local.mysql["name"]
  chart                 = local.mysql["chart"]
  timeout               = local.mysql["timeout"]
  force_update          = local.mysql["force_update"]
  recreate_pods         = local.mysql["recreate_pods"]
  wait                  = local.mysql["wait"]
  atomic                = local.mysql["atomic"]
  cleanup_on_fail       = local.mysql["cleanup_on_fail"]
  dependency_update     = local.mysql["dependency_update"]
  render_subchart_notes = local.mysql["render_subchart_notes"]
  replace               = local.mysql["replace"]
  reset_values          = local.mysql["reset_values"]
  reuse_values          = local.mysql["reuse_values"]
  skip_crds             = local.mysql["skip_crds"]
  verify                = local.mysql["verify"]
  namespace             = local.mysql["namespace"]
  values                = [local.values_mysql, local.mysql["extra_values"]]
  #depends_on            = [kubernetes_namespace.tools]
}
