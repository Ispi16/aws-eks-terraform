data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_ami" "eks_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon-eks-node-${data.aws_eks_cluster.cluster.version}-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values  = ["x86_64"]
  }

  owners = ["amazon"]
}

data "aws_kms_key" "eks_ng_key" {
  key_id = "alias/aws/ebs"
}
