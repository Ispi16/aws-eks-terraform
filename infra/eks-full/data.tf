data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "cluster" {
  name = local.vars.cluster_name
  depends_on = [
    module.control_plane
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.vars.cluster_name
  depends_on = [
    module.control_plane
  ]
}
