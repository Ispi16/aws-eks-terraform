output "cluster_name" {
  description = "Name of EKS cluster to which nodes are attached"
  value       = var.cluster_name
}

output "node_groups" {
  description = "Outputs from EKS node groups. Map of maps, keyed by variable"
  value       = aws_eks_node_group.eks_ng
}
