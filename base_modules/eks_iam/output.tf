output "cluster_role_name" {
  description = "Name of IAM role created for EKS cluster"
  value       = local.iam_role_cluster
}

output "cluster_role_arn" {
  description = "ARN of IAM role associated with EKS nodes"
  value       = local.cluster_role_arn
}

output "ng_iam_profile" {
  description = "Name of IAM instance profile associated with EKS nodes"
  value       = local.node_iam_profile
}

output "ng_role_name" {
  description = "Name of IAM role associated with EKS nodes"
  value       = local.iam_role_ng
}

output "ng_role_arn" {
  description = "ARN of IAM role associated with EKS nodes"
  value       = local.node_role_arn
}

output "aws_auth_roles" {
  description = "Roles for use in aws-auth ConfigMap"
  value = [
    {
      instance_role_arn = local.node_role_arn
      platform          = "linux"
    }
  ]
}
