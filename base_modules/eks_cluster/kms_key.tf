resource "aws_kms_key" "eks_key" {
  description             = "Key to encrypt k8s secrets"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = var.kms_enable_key_rotation
}

resource "aws_kms_alias" "eks_key_alias" {
  name          = "alias/eks-${var.cluster_name}"
  target_key_id = aws_kms_key.eks_key.key_id
}
