output "istio_base_helm_release_metadata" {
  description = "Block status of the deployed istio base helm release."
  value       = helm_release.istio-base.*.metadata
}

output "istiod_helm_release_metadata" {
  description = "Block status of the deployed istiod helm release."
  value       = helm_release.istiod.*.metadata
}

output "istio_cni_helm_release_metadata" {
  description = "Block status of the deployed istio cni helm release."
  value       = helm_release.istio-cni.*.metadata
}

output "istio_ingress_helm_release_metadata" {
  description = "Block status of the deployed istio ingress helm release."
  value       = helm_release.istio-ingress.*.metadata
}

output "istio_egress_helm_release_metadata" {
  description = "Block status of the deployed istio egress helm release."
  value       = helm_release.istio-egress.*.metadata
}
