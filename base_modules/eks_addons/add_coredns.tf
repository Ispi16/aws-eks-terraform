# Coredns
# https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html

resource "aws_eks_addon" "coredns" {
  count             = length(var.addon_coredns_version) > 0 ? 1 : 0  
  cluster_name      = var.cluster_name
  addon_name        = "coredns"
  addon_version     = var.addon_coredns_version
  resolve_conflicts = "OVERWRITE"
  tags              = var.custom_tags
}
