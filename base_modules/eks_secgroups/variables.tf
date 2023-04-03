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
  description = "Name of EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of VPC for launching EKS cluster."
  type        = string
}


variable "custom_tags" {
  description = "A map of key and value pair to assign to resources"
  type        = map(string)
  default     = {}
}
