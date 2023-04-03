resource "null_resource" "wait_for_cluster" {

  provisioner "local-exec" {
    environment = {
      ENDPOINT = data.aws_eks_cluster.cluster.endpoint
    }

    command = "until wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null; do sleep 4; done"
  }
}

resource "aws_eks_node_group" "eks_ng" {
  for_each                = { for ng in var.managed_node_groups : ng.name => ng }
  cluster_name            = var.cluster_name
  node_group_name_prefix  = join("-", [substr(var.cluster_name, 0, 3), each.key])
  node_role_arn           = length(lookup(each.value, "ng_role_arn")) > 0 ? lookup(each.value, "ng_role_arn") : var.node_role_arn
  subnet_ids              = var.subnet_ids
  instance_types          = lookup(each.value, "instance_types")
  capacity_type           = lookup(each.value, "capacity_type")

  scaling_config {
    max_size     = lookup(each.value, "max_size")
    min_size     = lookup(each.value, "min_size")
    desired_size = lookup(each.value, "desired_size")
  }

  launch_template {
    id      = aws_launch_template.eks_ng_template[each.key].id
    version = aws_launch_template.eks_ng_template[each.key].default_version
  }

  tags = merge(
    var.custom_tags,
    {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    {
    "k8s.io/cluster-autoscaler/enabled" = "true"
    },
    {
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    },
    {
    "eks:nodegroup-name" = join("-", [substr(var.cluster_name, 0, 3), each.key])
    }
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      # ignore changes to the cluster size, because it can be changed by autoscaling
      scaling_config[0].desired_size
    ]
  }

  dynamic "taint" {
    for_each = lookup(each.value, "k8s_taints")
    content {
      key    = taint.value["key"]
      value  = taint.value["value"]
      effect = taint.value["effect"]
    }
  }

  labels = lookup(each.value, "k8s_labels")

  timeouts {
    create = lookup(each.value, "ng_timeout")
    update = lookup(each.value, "ng_timeout")
    delete = lookup(each.value, "ng_timeout")
  }

  depends_on = [
    null_resource.wait_for_cluster,
    aws_launch_template.eks_ng_template,
  ]
}
