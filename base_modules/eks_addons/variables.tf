variable "environment" {
  description = <<EOT
                The environment a resource belongs to.  
                Ideally this matches the VPC Name, 
                but might not for legacy environments.
                EOT
  type = string
  default = ""
}

variable "base_environment" {
  description = <<EOT
                The base environment a resource belongs to.
                For example:  DEV, QA, UAT, or PROD.
                EOT
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = ""
}

variable "custom_tags" {
  description = "Map of key value pair to associate with EKS cluster."
  type        = map(string)
  default     = {}
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC url for the EKS cluster."
  type        = string
  default     = ""
}

variable "addon_coredns_version" {
  description = "Version of CoreDNS."
  type        = string
  default     = ""
}

variable "addon_kube_proxy_version" {
  description = "Version of Kube Proxy."
  type        = string
  default     = ""
}

variable "addon_awscni_version" {
  description = "Version of CNI."
  type        = string
  default     = ""
}

variable "addon_ebs_version" {
  description = "Version of EBS."
  type        = string
  default     = ""
}

variable "helm_defaults" {
  description = "Customize default Helm behavior, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "istio-base" {
  description = "Customize istio base chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "istiod" {
  description = "Customize istiod chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "istio-cni" {
  description = "Customize istio cni chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "istio-ingress" {
  description = "Customize istio ingress chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "istio-egress" {
  description = "Customize istio egress chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "prometheus" {
  description = "Customize prometheus chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "grafana" {
  description = "Customize grafana chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "filebeat" {
  description = "Customize filebeat chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}


variable "mysql" {
  description = "Customize mysql chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "kafka" {
  description = "Customize kafka chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "jaeger" {
  description = "Customize kiali chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "kiali" {
  description = "Customize kiali chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "argocd" {
  description = "Customize kiali chart, see posibile values in the terraform file"
  type        = any
  default     = {}
}

variable "install_metrics_server" {
  description = "True/False install metrics server."
  type        = bool
  default     = true
}

variable "install_opentelemetry_operator" {
  description = "True/False install opentelemetry operator."
  type        = bool
  default     = true
}
