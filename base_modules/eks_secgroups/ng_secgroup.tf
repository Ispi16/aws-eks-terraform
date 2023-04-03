resource "aws_security_group" "eks_ng_sg" {
  description             = "Security group for ${var.cluster_name} worker nodes"
  name                    = "${var.cluster_name}-ng-sg"
  vpc_id                  = var.vpc_id
  revoke_rules_on_delete  = true
  tags                    = merge(
    var.custom_tags,
    {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
  )
  depends_on              = [aws_security_group.cluster-sg, aws_security_group_rule.egress]
}

resource "aws_security_group_rule" "eks_ng_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.node_sg_id
}

resource "aws_security_group_rule" "nodeport" {
    description       = "nodeport"
    type              = "ingress"
    from_port         = 30000
    to_port           = 32768
    cidr_blocks       = ["0.0.0.0/0"]
    protocol          = "tcp"
    security_group_id = local.node_sg_id
}

resource "aws_security_group_rule" "node_to_node" {
  description              = "Allow node to communicate with each other"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = local.node_sg_id
  security_group_id        = local.node_sg_id
}

resource "aws_security_group_rule" "pods_to_control_plane_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = local.node_sg_id
  security_group_id        = local.cluster_sg_id
}

resource "aws_security_group_rule" "control_plane_to_pods_https" {
  description              = "Allow pods API server on port 443 to receive communication from cluster control plane"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = local.cluster_sg_id
  security_group_id        = local.node_sg_id
}

resource "aws_security_group_rule" "control_plane_to_pods" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = local.cluster_sg_id
  security_group_id        = local.node_sg_id
}

resource "aws_security_group_rule" "pods_to_control_plane" {
  description              = "Allow cluster security group to send communication to worker security groups"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = local.node_sg_id
  security_group_id        = local.cluster_sg_id
}

resource "aws_security_group_rule" "control_plane_egress_to_worker_https" {
  description              = "Allow cluster security group to send communication to worker security groups"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = local.node_sg_id
  security_group_id        = local.cluster_sg_id
}
