# Metrics Server
# https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html

resource "null_resource" "install_metrics_server" {
  count      = var.install_metrics_server ? 1 : 0
  depends_on = [kubernetes_namespace.monitoring]

  provisioner "local-exec" {
    command = <<-EOT
      if [ -n "$(kubectl --kubeconfig ~/.kube/config get deployment metrics-server -n kube-system)" ]
      then
        echo "Metrics Server is installed"
      else
        kubectl --kubeconfig ~/.kube/config apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
      fi
    EOT

    interpreter = ["bash", "-c"]
  }
  
  triggers = {
    always_run = uuid()
  }
}
