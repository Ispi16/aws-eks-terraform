resource "aws_iam_role" "eks_ng_role" {
  name                  = "${var.cluster_name}-ng-role"
  force_detach_policies = true
  depends_on            = [null_resource.check_aws_credentials_are_available]
  assume_role_policy    = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_instance_profile" "eks_ng_vm_profile" {
  name        = "${var.cluster_name}-ng-profile"
  role        = local.iam_role_ng
}

resource "aws_iam_role_policy_attachment" "ng_worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = local.iam_role_ng
}

resource "aws_iam_role_policy_attachment" "ng_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = local.iam_role_ng
}

resource "aws_iam_role_policy_attachment" "ng_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = local.iam_role_ng
}

# SSM
resource "aws_iam_role_policy_attachment" "ng_ssm_managed" {
  policy_arn = format("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore")
  role       = local.iam_role_ng
}

# Allow workers to send logs to CloudWatch
resource "aws_iam_role_policy_attachment" "ng_cloudwatchagentserver_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = local.iam_role_ng
}

# Policy required for cluster autoscaling
resource "aws_iam_role_policy" "eks_scaling_policy" {
  name   = "${var.cluster_name}-ng-role-policy"
  role   = local.iam_role_ng

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:AttachVolume",
          "ec2:ModifyVolume",
          "ec2:DetachVolume",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeTags",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeVolumesModifications",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeVolumes",
          "ec2:DescribeInstances"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "eks_nlb_policy" {
  name   = "${var.cluster_name}-ng-nlb-role-policy"
  role   = local.iam_role_ng

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVpcs",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancerPolicies",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:SetLoadBalancerPoliciesOfListener"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVpcs",
                "ec2:DescribeRegions"
            ],
            "Resource": "*"
        }
    ]
  }
EOF
}

resource "aws_iam_role_policy_attachment" "ng_additional_policies" {
  count      = length(var.ng_additional_policies)
  policy_arn = var.ng_additional_policies[count.index]
  role       = local.iam_role_ng
}
