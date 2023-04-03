# AWS VPC CNI for networking
# https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html

resource "aws_eks_addon" "vpc-cni" {
  count             = length(var.addon_awscni_version) > 0 ? 1 : 0  
  cluster_name      = var.cluster_name
  addon_name        = "vpc-cni"
  addon_version     = var.addon_awscni_version
  resolve_conflicts = "OVERWRITE"
  tags              = var.custom_tags
}
