resource "aws_eks_cluster" "eks_cluster" {
  name                      = var.cluster_name
  version                   = var.eks_version == "" ? null : var.eks_version
  role_arn                  = var.cluster_role_arn
  enabled_cluster_log_types = var.eks_log_types

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.enable_private_access
    endpoint_public_access  = var.enable_public_access
    public_access_cidrs     = var.enable_public_access == true ? var.public_allow_cidr_blocks : null
    security_group_ids      = var.default_cluster_sg_id
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_key.arn
    }
    resources = ["secrets"]
  }

  timeouts {
    create = var.cluster_timeout
    delete = var.cluster_timeout
    update = var.cluster_timeout
  }

  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_kms_key.eks_key,
    aws_kms_alias.eks_key_alias
  ]

  tags = var.custom_tags
}
