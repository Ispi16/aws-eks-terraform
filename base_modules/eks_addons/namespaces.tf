# https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/

# Namespace used for Ingress traffic
resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"

    labels = {
     "istio-injection" = "enabled"
    }
  }
}

# Namespace used for Observability stack related to monitoring, logging and tracing
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"

    labels = {
     "istio-injection" = "enabled"
    }
  }
}
