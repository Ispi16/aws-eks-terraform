locals {
  cluster_sg_id = join("", aws_security_group.cluster-sg.*.id)
  node_sg_id    = join(", ", aws_security_group.eks_ng_sg.*.id)
}
