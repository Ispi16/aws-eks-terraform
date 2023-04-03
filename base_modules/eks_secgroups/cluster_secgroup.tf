resource "aws_security_group" "cluster-sg" {
  description             = "Security Group for EKS cluster"
  name                    = var.cluster_name
  vpc_id                  = var.vpc_id
  revoke_rules_on_delete  = true
  tags                    = var.custom_tags
}

resource "aws_security_group_rule" "cluster_ingress_https" {
    description       = "https traffic"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = local.cluster_sg_id
    type              = "ingress"
}

resource "aws_security_group_rule" "nodeport_master" {
    description       = "nodeport"
    from_port         = 30000
    to_port           = 32768
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = local.cluster_sg_id
    type              = "ingress"
}

resource "aws_security_group_rule" "nodeport_master_udp" {
    description       = "nodeport"
    from_port         = 30000
    to_port           = 32768
    protocol          = "udp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = local.cluster_sg_id
    type              = "ingress"
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.cluster_sg_id
  type              = "egress"
}
