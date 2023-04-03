data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

data "template_file" "map_instances" {
  count     = length(var.map_instances)
  template  = file("${path.module}/templates/worker-role.tpl")
  vars      = var.map_instances[count.index]
}
