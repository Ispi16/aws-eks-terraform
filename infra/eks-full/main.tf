# Required terraform version and providers
terraform {
  required_version = "~> 0.15.5"

  required_providers {
    aws        = "~> 3.65.0"
    local      = "~> 2.1.0"
    kubernetes = "~> 2.12.1"
    null       = "~> 3.1.0"
    template   = "~> 2.2.0"
    helm       = "~> 2.5.0"
  }

# Configuration for remote state
  backend "s3" {
    bucket                  = "terraform-state-bucket"
    key                     = "terraform/kubernetes/state"
    dynamodb_table          = "terraform-state"
    profile                 = "terraform_state"
    shared_credentials_file = "~/.aws/credentials"
    region                  = "us-east-1"
    #role_arn                = "arn:aws:iam::670868695205:role/terraform-state"
  }
}

# Create IAM resources
module "eks_iam" {
  source                      = "../../base_modules/eks_iam"
  cluster_name                = local.vars.cluster_name
  cluster_additional_policies = local.vars.cluster_additional_policies   
  ng_additional_policies      = local.vars.ng_additional_policies
}

# Create security groups
module "eks_secgroups" {
  source            = "../../base_modules/eks_secgroups"
  depends_on        = [module.eks_iam]
  environment       = local.vars.environment
  base_environment  = local.vars.base_environment
  cluster_name      = local.vars.cluster_name
  vpc_id            = local.vars.vpc_id
  custom_tags       = local.vars.custom_tags
}

# Provision the control plane of the kubernetes cluster
module "control_plane" {
  source                      = "../../base_modules/eks_cluster"
  depends_on                  = [module.eks_iam, module.eks_secgroups]
  environment                 = local.vars.environment
  base_environment            = local.vars.base_environment
  cluster_name                = local.vars.cluster_name
  region                      = local.vars.region
  aws_provider_profile        = var.aws_provider_profile
  cluster_role_arn            = module.eks_iam.cluster_role_arn
  vpc_id                      = local.vars.vpc_id
  default_cluster_sg_id       = [module.eks_secgroups.cluster_default_sg_id]
  subnet_ids                  = local.vars.subnet_ids
  eks_version                 = local.vars.eks_version
  eks_log_types               = local.vars.eks_log_types
  kms_deletion_window_in_days = local.vars.kms_deletion_window_in_days
  kms_enable_key_rotation     = local.vars.kms_enable_key_rotation
  create_oidc_provider        = local.vars.create_oidc_provider
  cluster_timeout             = local.vars.cluster_timeout
  enable_private_access       = local.vars.enable_private_access
  enable_public_access        = local.vars.enable_public_access
  public_allow_cidr_blocks    = local.vars.public_allow_cidr_blocks
  custom_tags                 = local.vars.custom_tags
}

# Add or remove users/roles/accounts to the kubernetes cluster
module "aws_auth" {
  source            = "../../base_modules/eks_awsauth"
  depends_on        = [module.control_plane]
  environment       = local.vars.environment
  base_environment  = local.vars.base_environment
  cluster_name      = module.control_plane.id
  endpoint          = module.control_plane.endpoint
  map_instances     = concat(module.eks_iam.aws_auth_roles)
  map_accounts      = local.vars.map_accounts
  map_roles         = local.vars.map_roles
  map_users         = local.vars.map_users
}

# Connect nodegroups instances to the control plan of the kubernetes cluster
module "node_groups" {
  source              = "../../base_modules/eks_nodegroups"
  depends_on          = [module.aws_auth]
  environment         = local.vars.environment
  base_environment    = local.vars.base_environment
  cluster_name        = module.control_plane.id
  node_role_arn       = module.eks_iam.ng_role_arn
  default_ng_sg_id    = [module.eks_secgroups.ng_default_sg_id]
  managed_node_groups = local.vars.managed_node_groups
  subnet_ids          = local.vars.subnet_ids
  custom_tags         = local.vars.custom_tags
}

# Install different addons on the kubernetes addons
module "eks-addons" {
  source                         = "../../base_modules/eks_addons"
  depends_on                     = [module.node_groups]
  environment                    = local.vars.environment
  base_environment               = local.vars.base_environment
  cluster_name                   = module.control_plane.id
  cluster_oidc_issuer_url        = module.control_plane.oidc_url
  addon_awscni_version           = local.vars.addon_awscni_version
  addon_coredns_version          = local.vars.addon_coredns_version
  addon_kube_proxy_version       = local.vars.addon_kube_proxy_version
  addon_ebs_version              = local.vars.addon_ebs_version
  helm_defaults                  = local.vars.helm_defaults
  istio-base                     = local.vars.istio-base
  istiod                         = local.vars.istiod
  istio-cni                      = local.vars.istio-cni
  istio-ingress                  = local.vars.istio-ingress
  istio-egress                   = local.vars.istio-egress
  prometheus                     = local.vars.prometheus
  grafana                        = local.vars.grafana
  filebeat                       = local.vars.filebeat
  kafka                          = local.vars.kafka
  mysql                          = local.vars.mysql
  jaeger                         = local.vars.jaeger
  kiali                          = local.vars.kiali
  argocd                         = local.vars.argocd
  install_opentelemetry_operator = local.vars.install_opentelemetry_operator
  install_metrics_server         = local.vars.install_metrics_server
  custom_tags                    = local.vars.custom_tags
}
