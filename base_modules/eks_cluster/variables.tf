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

variable "aws_provider_profile" {
  description = <<EOT
                The user profile of your AWS credentials 
                that can execute the terraform plan in the given VPC.
                EOT
  type        = string
  default     = ""
}

variable "region" {
  description = "Region in AWS to apply changes"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "ID of VPC for launching EKS cluster."
  type        = string
}

variable "cluster_name" {
  description = "Name for EKS cluster."
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN to be used by cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet ids to be used for launching EKS cluster."
  type        = list(string)
}

variable "default_cluster_sg_id" {
  description = "List of security group id to be used for launching EKS cluster."
  type        = list(string)
}

variable "kms_deletion_window_in_days" {
  description = "Days after which KMS key to be deleted."
  type        = number
  default     = 30
}

variable "kms_enable_key_rotation" {
  description = "Whether to enable automatic key rotation."
  type        = bool
  default     = false
}

variable "eks_version" {
  description = "Version of EKS cluster"
  type        = string
  default     = ""
}

variable "enable_private_access" {
  description = "Whether to enable private access of EKS cluster."
  type        = bool
  default     = true
}

variable "enable_public_access" {
  description = "Whether to allow EKS cluster to be accessed publicly."
  type        = bool
  default     = false
}

variable "eks_log_types" {
  description = <<EOT
                List of logs to be enabled for EKS cluster.
                These logs will be stored in CloudWatch Log Group. 
                **Valid values:** api, audit, authenticator, controllerManager, scheduler
                EOT
  type        = list(string)
  default     = []
}

variable "create_oidc_provider" {
  description = "Whether to create custom IAM OIDC provider for EKS cluster"
  type        = bool
  default     = true
}

variable "cluster_timeout" {
  description = "Timeout to create/delete/update the cluster"
  type        = string
  default     = "30m"
}

variable "public_allow_cidr_blocks" {
  description = "List of CIDR blocks to be allowed to connect to the EKS cluster"
  type        = list(string)
  default     = []
}

variable "custom_tags" {
  description = "Map of key value pair to associate with EKS cluster"
  type        = map(string)
  default     = {}
}
