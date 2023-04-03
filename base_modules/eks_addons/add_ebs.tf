# EBS CSI driver
# https://docs.aws.amazon.com/eks/latest/userguide/managing-ebs-csi.html

resource "aws_eks_addon" "ebs" {
  count             = length(var.addon_ebs_version) > 0 ? 1 : 0  
  cluster_name      = var.cluster_name
  addon_name        = "aws-ebs-csi-driver"
  addon_version     = var.addon_ebs_version
  resolve_conflicts = "OVERWRITE"
  tags              = var.custom_tags
}
