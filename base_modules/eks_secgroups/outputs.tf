output "cluster_default_sg_id" {
  description = "ID of security group created and attached to EKS cluster"
  value       = local.cluster_sg_id
}

output "ng_default_sg_id" {
  description = "IDs of security group attached to EKS node"
  value       = local.node_sg_id
}
