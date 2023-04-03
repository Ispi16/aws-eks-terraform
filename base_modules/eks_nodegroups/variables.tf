variable "environment" {
  description = <<EOT
                The environment a resource belongs to.  
                Ideally this matches the VPC Name, 
                but might not for legacy environments.
                EOT
  type        = string
  default     = ""
}

variable "base_environment" {
  description = "The base environment a resource belongs to.  For example:  DEV, QA, UAT, or PROD."
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "ARN to be used by nodegroups"
  type        = string
}

variable "managed_node_groups" {
  description = <<EOT
                Define nodegroups using variables:
                {
                  name                        = "ng"
                  min_size                    = 1
                  max_size                    = 3
                  desired_size                = 1
                  instance_types              = ["m4.large"]
                  capacity_type               = "SPOT"
                  ssh_key_name                = "Ansible"
                  volume_size                 = 50
                  volume_type                 = "gp3"
                  ami_id                      = ""
                  bootstrap_extra_args        = ""
                  k8s_taints                  = []
                  k8s_labels                  = {}
                  ng_role_arn                 = ""
                  ng_security_group_id        = []
                  ng_timeout                  = "40m"
                  ebs_optimized               = true
                  associate_public_ip_address = false
                  device_name                 = "/dev/xvda"
                  monitoring                  = true
                },
                EOT
  type        = any
  default     = []
}

variable "subnet_ids" {
  description = "List of subnet ids to be used for launching EKS workers."
  type        = list(string)
}

variable "default_ng_sg_id" {
  description = "List of security group id to be used for launching EKS workers."
  type        = list(string)
}

variable "custom_tags" {
  description = "A map of key and value pair to assign to resources"
  type        = map(string)
  default     = {}
}
