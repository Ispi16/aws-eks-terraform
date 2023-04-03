output "endpoint" {
  description = "Endpoint of EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "id" {
  description = "Name of EKS cluster"
  value       = aws_eks_cluster.eks_cluster.id
}

output "arn" {
  description = "ARN of EKS cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "oidc_url" {
  description = "Issuer URL for the OpenID Connect identity provider"
  value       = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}

output "oidc_provider_arn" {
  description = "ARN of IAM OIDC provider for EKS cluster"
  value       = var.create_oidc_provider ? join(",", aws_iam_openid_connect_provider.eks_oidc.*.arn) : null
}

output "status" {
  description = "Status of EKS cluster. Valid values: CREATING, ACTIVE, DELETING, FAILED"
  value       = aws_eks_cluster.eks_cluster.status
}
