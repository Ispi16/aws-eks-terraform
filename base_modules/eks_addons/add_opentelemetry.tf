# Opentelemetry operator
# https://github.com/open-telemetry/opentelemetry-operator

resource "null_resource" "install_opentelemetry_operator" {
  count      = var.install_opentelemetry_operator ? 1 : 0
  depends_on = [kubernetes_namespace.monitoring]

  provisioner "local-exec" {
    command = <<-EOT
      if [ -n "$(kubectl --kubeconfig ~/.kube/config get ns cert-manager )" ]
      then
        echo "Cert-manager is installed"
      else
        kubectl --kubeconfig ~/.kube/config apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
      fi
      if [ -n "$(kubectl --kubeconfig ~/.kube/config get ns opentelemetry-operator-system )" ]
      then
        echo "Opentelemetry Operator is installed"
      else
        kubectl --kubeconfig ~/.kube/config apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
      fi
    EOT

    interpreter = ["bash", "-c"]
  }
  
  triggers = {
    always_run = uuid()
  }
}
