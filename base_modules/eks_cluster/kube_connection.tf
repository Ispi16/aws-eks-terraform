resource "null_resource" "update_kubeconfig_with_cluster_info" {
  triggers = {
    always_run = uuid()
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws eks \
        --profile ${var.aws_provider_profile} \
        --region ${var.region} \
        update-kubeconfig \
        --name ${var.cluster_name}
      export KUBE_CONFIG_PATH=~/.kube/config
    EOT
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}
