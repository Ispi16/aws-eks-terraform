resource "aws_launch_template" "eks_ng_template" {
  for_each               = { for ng in var.managed_node_groups : ng.name => ng }
  name_prefix            = join("-", [substr(var.cluster_name, 0, 3), each.key])
  image_id               = lookup(each.value, "ami_id") == "" ? data.aws_ami.eks_ami.image_id : lookup(each.value, "ami_id")
  key_name               = lookup(each.value, "ssh_key_name") == "" ? null : lookup(each.value, "ssh_key_name")
  update_default_version = lookup(each.value, "modify_ng")
  ebs_optimized          = lookup(each.value, "ebs_optimized", true)

  user_data = base64encode(templatefile("${path.module}/templates/user-data.tpl", {
    cluster_name               = var.cluster_name
    cluster_endpoint           = data.aws_eks_cluster.cluster.endpoint
    certificate_authority_data = data.aws_eks_cluster.cluster.certificate_authority[0].data
    bootstrap_extra_args       = lookup(each.value, "bootstrap_extra_args")
    ami_id                     = lookup(each.value, "ami_id") == "" ? data.aws_ami.eks_ami.image_id : lookup(each.value, "ami_id")
    node_group_name            = join("-", [substr(var.cluster_name, 0, 3), each.key])
    capacity_type              = lookup(each.value, "capacity_type")
  }))

  network_interfaces {
    associate_public_ip_address = lookup(each.value, "associate_public_ip_address", false)
    security_groups             = length(lookup(each.value, "ng_security_group_id")) > 0 ? lookup(each.value, "ng_security_group_id") : var.default_ng_sg_id
    delete_on_termination       = true
  }

  block_device_mappings {
    device_name = lookup(each.value, "device_name", "/dev/xvda")

    ebs {
      volume_size           = lookup(each.value, "volume_size")
      volume_type           = lookup(each.value, "volume_type")
      encrypted             = true
      kms_key_id            = data.aws_kms_key.eks_ng_key.arn
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = lookup(each.value, "monitoring", true)
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  # Tags that are for instances
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.custom_tags,
      {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      },
      {
      "eks:nodegroup-name" = join("-", [substr(var.cluster_name, 0, 3), each.key])
      }
    )
  }

  # Tags that are for network interfaces
  tag_specifications {
    resource_type = "network-interface"
    tags = merge(
      var.custom_tags,
      {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      },
      {
      "eks:nodegroup-name" = join("-", [substr(var.cluster_name, 0, 3), each.key])
      }
    )
  }

  # Tags that are for Launch templates
  tags = merge(
    var.custom_tags,
    {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    {
    "eks:nodegroup-name" = join("-", [substr(var.cluster_name, 0, 3), each.key])
    }
  )

  # Prevent premature access of security group roles and policies by pods that
  # require permissions on create/destroy that depend on workers.
  depends_on = [
    data.aws_kms_key.eks_ng_key
  ]
}
