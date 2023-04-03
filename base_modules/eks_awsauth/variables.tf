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

variable "endpoint" {
  description = "Endpoint of the EKS cluster."
  type        = string
  default     = ""
}

variable "map_instances" {
  description = "IAM instance roles of the instances to add to the aws-auth configmap"
  type        = list(object({
    instance_role_arn = string
    platform          = string
  }))
  default     = []
}

variable "map_accounts" {
  description = <<EOT
                Additional AWS account numbers to add to the aws-auth configmap. 
                Example: [ "777777777777", "888888888888" ]
                EOT
  type        = list(string)
  default     = []
}

variable "map_roles" {
  description = <<EOT
                Additional IAM roles to add to the aws-auth configmap.
                Example: [ { "groups": [ "system:masters" ], 
                          "rolearn": "arn:aws:iam::66666666666:role/role1", 
                          "username": "role1" } ]
                EOT
  type        = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default     = []
}

variable "map_users" {
  description = <<EOT
                Additional IAM users to add to the aws-auth configmap
                Example: [ { "groups": [ "system:masters" ], 
                          "userarn": "arn:aws:iam::66666666666:user/user1", 
                          "username": "user1" }]
                EOT
  type        = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default     = []
}
