#######################################
# Local Vars imported from yaml
#######################################

locals {
  all_ipv4        = "0.0.0.0/0"
  default_file    = "./env_vars/default/main.yml"
  default_content = fileexists(local.default_file) ? file(local.default_file) : "NoSettingsFileFound: true"
  default_vars    = yamldecode(local.default_content)
  env_file        = "./env_vars/${terraform.workspace}/main.yml"
  env_content     = fileexists(local.env_file) ? file(local.env_file) : "NoSettingsFileFound: true"
  env_vars        = yamldecode(local.env_content)
  vars            = merge(local.default_vars, local.env_vars)
}

#######################################
# General Vars
#######################################

variable "aws_cred_file" {
  default     = "~/.aws/credentials"
  description = "The location of the credentials file where the profile to execute a terraform plan resides."
  type        = string
}

variable "aws_provider_profile" {
  description = "The user profile of your AWS credentials that can execute the terraform plan in the given VPC."
  type        = string
}
