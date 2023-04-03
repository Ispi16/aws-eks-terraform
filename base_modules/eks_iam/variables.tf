variable "cluster_name" {
  description = "Name for EKS cluster."
  type        = string
}

variable "cluster_additional_policies" {
  description = "Additional policies to be added to workers"
  type        = list(string)
  default     = []
}

variable "ng_additional_policies" {
  description = "Additional policies to be added to nodegroups"
  type        = list(string)
  default     = []
}
