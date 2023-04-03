output "cluster_role_name" {
  description = "Role name of EKS control plane"
  value       = module.eks_iam.cluster_role_name
}

output "cluster_role_arn" {
  description = "ARN of IAM role associated with EKS nodes"
  value       = module.eks_iam.cluster_role_arn
}

output "ng_iam_profile" {
  description = "Name of IAM instance profile associated with EKS nodes"
  value       = module.eks_iam.ng_iam_profile
}

output "ng_role_name" {
  description = "Name of IAM role associated with EKS nodes"
  value       = module.eks_iam.ng_role_name
}

output "ng_role_arn" {
  description = "ARN of IAM role associated with EKS nodes"
  value       = module.eks_iam.ng_role_arn
}

output "cluster_endpoint" {
  description = "Endpoint of EKS cluster"
  value       = module.control_plane.endpoint
}

output "cluster_id" {
  description = "Name of EKS cluster"
  value       = module.control_plane.id
}

output "oidc_url" {
  description = "Issuer URL for the OpenID Connect identity provider"
  value       = module.control_plane.oidc_url
}

output "cluster_status" {
  description = "Status of EKS cluster. Valid values: CREATING, ACTIVE, DELETING, FAILED"
  value       = module.control_plane.status
}

output "cluster_oidc_provider_arn" {
  description  = "ARN of IAM OIDC provider for EKS cluster"
  value        = module.control_plane.oidc_provider_arn
}

output "cluster_sg_id" {
  description = "ID of security group created and attached to EKS cluster"
  value       = module.eks_secgroups.cluster_default_sg_id
}

output "node_groups" {
  description = "Outputs from EKS node groups. Map of maps, keyed by variable"
  value       = module.node_groups.node_groups
}

output "nodegroup_sg_ids" {
  description = "Security group id of the nodegroup"
  value       = module.eks_secgroups.ng_default_sg_id
}

output "aws_auth" {
  description = "Configmap of aws auth"
  value       = module.aws_auth.config_map_aws_auth
}

output "istio_base_helm_release_metadata" {
  description = "Block status of the deployed istio base helm release."
  value       = module.eks-addons.istio_base_helm_release_metadata
}

output "istiod_helm_release_metadata" {
  description = "Block status of the deployed istiod helm release."
  value       = module.eks-addons.istiod_helm_release_metadata
}

output "istio_cni_helm_release_metadata" {
  description = "Block status of the deployed istio cni helm release."
  value       = module.eks-addons.istio_cni_helm_release_metadata
}

output "istio_ingress_helm_release_metadata" {
  description = "Block status of the deployed istio ingress helm release."
  value       = module.eks-addons.istio_ingress_helm_release_metadata
}

output "istio_egress_helm_release_metadata" {
  description = "Block status of the deployed istio egress helm release."
  value       = module.eks-addons.istio_egress_helm_release_metadata
}
