# Kube-proxy
# https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html

resource "aws_eks_addon" "kube_proxy" {
  count             = length(var.addon_kube_proxy_version) > 0 ? 1 : 0
  cluster_name      = var.cluster_name
  addon_name        = "kube-proxy"
  resolve_conflicts = "OVERWRITE"
  addon_version     = var.addon_kube_proxy_version
  tags              = var.custom_tags
}
