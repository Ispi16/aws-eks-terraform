# Istio Base
# https://github.com/istio/istio/tree/master/manifests/charts/base

locals {
  istio-base = merge(
    local.helm_defaults,
    {
      enabled   = true
      name      = "istio-base"
      chart     = "${path.module}/charts/istio/base"
      namespace = "istio-system"
    },
    var.istio-base
  )

  values_istio-base = ""
}

resource "helm_release" "istio-base" {
  count                 = local.istio-base["enabled"] ? 1 : 0
  name                  = local.istio-base["name"]
  chart                 = local.istio-base["chart"]
  timeout               = local.istio-base["timeout"]
  force_update          = local.istio-base["force_update"]
  recreate_pods         = local.istio-base["recreate_pods"]
  wait                  = local.istio-base["wait"]
  atomic                = local.istio-base["atomic"]
  cleanup_on_fail       = local.istio-base["cleanup_on_fail"]
  dependency_update     = local.istio-base["dependency_update"]
  render_subchart_notes = local.istio-base["render_subchart_notes"]
  replace               = local.istio-base["replace"]
  reset_values          = local.istio-base["reset_values"]
  reuse_values          = local.istio-base["reuse_values"]
  skip_crds             = local.istio-base["skip_crds"]
  verify                = local.istio-base["verify"]
  namespace             = local.istio-base["namespace"]
  values                = [local.values_istio-base, local.istio-base["extra_values"]]
  depends_on            = [kubernetes_namespace.istio-system]
}

# Istio CNI
# https://github.com/istio/cni
# Installation in `kube-system` is recommended to ensure the [`system-node-critical`]
#(https://kubernetes.io/docs/tasks/administer-cluster/guaranteed-scheduling-critical-addon-pods/)
#`priorityClassName` can be used.

locals {
  istio-cni = merge(
    local.helm_defaults,
    {
      enabled   = true
      name      = "istio-cni"
      chart     = "${path.module}/charts/istio/istio-cni"
      namespace = "kube-system"
      create_ns = false
    },
    var.istio-cni
  )

  values_istio-cni = <<-VALUES
global:
  hub: gcr.io/istio-release
  tag: 1.15.0
VALUES
}

resource "helm_release" "istio-cni" {
  count                 = local.istio-cni["enabled"] ? 1 : 0
  name                  = local.istio-cni["name"]
  chart                 = local.istio-cni["chart"]
  timeout               = local.istio-cni["timeout"]
  force_update          = local.istio-cni["force_update"]
  recreate_pods         = local.istio-cni["recreate_pods"]
  wait                  = local.istio-cni["wait"]
  atomic                = local.istio-cni["atomic"]
  cleanup_on_fail       = local.istio-cni["cleanup_on_fail"]
  dependency_update     = local.istio-cni["dependency_update"]
  render_subchart_notes = local.istio-cni["render_subchart_notes"]
  replace               = local.istio-cni["replace"]
  reset_values          = local.istio-cni["reset_values"]
  reuse_values          = local.istio-cni["reuse_values"]
  skip_crds             = local.istio-cni["skip_crds"]
  verify                = local.istio-cni["verify"]
  namespace             = local.istio-cni["namespace"]
  values                = [local.values_istio-cni, local.istio-cni["extra_values"]]
  depends_on            = [helm_release.istio-base]
}

# Istio control plane
# https://istio.io/latest/docs/ops/deployment/architecture/

locals {
  istiod = merge(
    local.helm_defaults,
    {
      enabled   = true
      name      = "istiod"
      chart     = "${path.module}/charts/istio/istio-control/istio-discovery"
      namespace = "istio-system"
    },
    var.istiod
  )

  values_istiod = <<-VALUES
pilot:
  autoscaleMin: 2
global:
  hub: gcr.io/istio-release
  tag: 1.15.0
meshConfig:
  accessLogFile: /dev/stdout
VALUES
}

resource "helm_release" "istiod" {
  count                 = local.istiod["enabled"] ? 1 : 0
  name                  = local.istiod["name"]
  chart                 = local.istiod["chart"]
  timeout               = local.istiod["timeout"]
  force_update          = local.istiod["force_update"]
  recreate_pods         = local.istiod["recreate_pods"]
  wait                  = local.istiod["wait"]
  atomic                = local.istiod["atomic"]
  cleanup_on_fail       = local.istiod["cleanup_on_fail"]
  dependency_update     = local.istiod["dependency_update"]
  render_subchart_notes = local.istiod["render_subchart_notes"]
  replace               = local.istiod["replace"]
  reset_values          = local.istiod["reset_values"]
  reuse_values          = local.istiod["reuse_values"]
  skip_crds             = local.istiod["skip_crds"]
  verify                = local.istiod["verify"]
  namespace             = local.istiod["namespace"]
  values                = [local.values_istiod, local.istiod["extra_values"]]
  depends_on            = [helm_release.istio-base]
}

# Istio egress gateway
# https://istio.io/latest/docs/tasks/traffic-management/egress/

locals {
  istio-egress = merge(
    local.helm_defaults,
    {
      enabled   = true
      name      = "istio-egress"
      chart     = "${path.module}/charts/istio/gateways/istio-egress"
      namespace = "istio-system"
    },
    var.istio-egress
  )

  values_istio-egress = <<-VALUES
gateways:
  istio-egressgateway:
    autoscaleMin: 2
    autoscaleMax: 6
global:
  hub: gcr.io/istio-release
  tag: 1.15.0
VALUES
}

resource "helm_release" "istio-egress" {
  count                 = local.istio-egress["enabled"] ? 1 : 0
  name                  = local.istio-egress["name"]
  chart                 = local.istio-egress["chart"]
  timeout               = local.istio-egress["timeout"]
  force_update          = local.istio-egress["force_update"]
  recreate_pods         = local.istio-egress["recreate_pods"]
  wait                  = local.istio-egress["wait"]
  atomic                = local.istio-egress["atomic"]
  cleanup_on_fail       = local.istio-egress["cleanup_on_fail"]
  dependency_update     = local.istio-egress["dependency_update"]
  render_subchart_notes = local.istio-egress["render_subchart_notes"]
  replace               = local.istio-egress["replace"]
  reset_values          = local.istio-egress["reset_values"]
  reuse_values          = local.istio-egress["reuse_values"]
  skip_crds             = local.istio-egress["skip_crds"]
  verify                = local.istio-egress["verify"]
  namespace             = local.istio-egress["namespace"]
  values                = [local.values_istio-egress, local.istio-egress["extra_values"]]
  depends_on            = [helm_release.istiod]
}

# Istio ingress gateway
# https://istio.io/latest/docs/tasks/traffic-management/ingress/

locals {
  istio-ingress = merge(
    local.helm_defaults,
    {
      enabled   = true
      name      = "istio-ingress"
      chart     = "${path.module}/charts/istio/gateways/istio-ingress"
      namespace = "istio-system"
    },
    var.istio-ingress
  )

  values_istio-ingress = <<-VALUES
gateways:
  istio-ingressgateway:
    type: NodePort
    autoscaleMin: 2
    autoscaleMax: 10
global:
  hub: gcr.io/istio-release
  tag: 1.15.0
VALUES
}

resource "helm_release" "istio-ingress" {
  count                 = local.istio-ingress["enabled"] ? 1 : 0
  name                  = local.istio-ingress["name"]
  chart                 = local.istio-ingress["chart"]
  timeout               = local.istio-ingress["timeout"]
  force_update          = local.istio-ingress["force_update"]
  recreate_pods         = local.istio-ingress["recreate_pods"]
  wait                  = local.istio-ingress["wait"]
  atomic                = local.istio-ingress["atomic"]
  cleanup_on_fail       = local.istio-ingress["cleanup_on_fail"]
  dependency_update     = local.istio-ingress["dependency_update"]
  render_subchart_notes = local.istio-ingress["render_subchart_notes"]
  replace               = local.istio-ingress["replace"]
  reset_values          = local.istio-ingress["reset_values"]
  reuse_values          = local.istio-ingress["reuse_values"]
  skip_crds             = local.istio-ingress["skip_crds"]
  verify                = local.istio-ingress["verify"]
  namespace             = local.istio-ingress["namespace"]
  values                = [local.values_istio-ingress, local.istio-ingress["extra_values"]]
  depends_on            = [helm_release.istiod]
}
