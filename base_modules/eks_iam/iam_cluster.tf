resource "aws_iam_role" "eks_role" {
  name                  = "${var.cluster_name}-eks-cluster-role"
  force_detach_policies = true
  depends_on            = [null_resource.check_aws_credentials_are_available]
  assume_role_policy    = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = local.iam_role_cluster
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = local.iam_role_cluster
}

resource "aws_iam_role_policy_attachment" "eks_VPCResourceController_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = local.iam_role_cluster
}

resource "aws_iam_role_policy_attachment" "cluster_additional_policies" {
  count      = length(var.cluster_additional_policies)
  policy_arn = var.cluster_additional_policies[count.index]
  role       = local.iam_role_cluster
}
