locals {
    iam_role_cluster  = aws_iam_role.eks_role.name
    iam_role_ng       = aws_iam_role.eks_ng_role.name
    cluster_role_arn  = aws_iam_role.eks_role.arn
    node_iam_profile  = aws_iam_instance_profile.eks_ng_vm_profile.name
    node_role_arn     = aws_iam_role.eks_ng_role.arn
}
