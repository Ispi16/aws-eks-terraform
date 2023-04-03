/*
  Start of resource tagging logic to update the provided vpc and its subnets with the necessary tags for eks to work
  The toset() function is actually multiplexing the resource block, one for every item in the set. It is what allows 
  for setting a tag on each of the subnets in the vpc.
  https://aws.amazon.com/blogs/containers/de-mystifying-cluster-networking-for-amazon-eks-worker-nodes/
  Public + Private subnets
  This VPC architecture is considered the best practice for common Kubernetes workloads on AWS. 
  In this configuration, nodes are instantiated in the private subnets and ingress resources 
  (like load balancers) are instantiated in the public subnets. 
  This allows for maximum control over traffic to the nodes and works well for a majority of Kubernetes applications.
  Configuration best practices:
  Because you are not launching nodes in the public subnets, it’s not required to set mapPublicIpOnLaunch for public subnets.
  mapPublicIpOnLaunch should be set to FALSE for the private subnets.
  Nodes do not need a value for AssociatePublicIpAddress (do not include this value in the CFN template or API call)
  The cluster endpoint can be set to enable public, private, or both (public + private). 
  Depending on the setting of the cluster endpoint, the node traffic will flow through the NAT gateway or the ENI.
  Learn about this architecture in the Amazon VPC documentation. 
  Start a VPC with the public+private subnet configuration using this CloudFormation template: 
  https://amazon-eks.s3.us-west-2.amazonaws.com/cloudformation/2020-03-23/amazon-eks-vpc-private-subnets.yaml
  Also, note that this is the default VPC configuration for eksctl.
*/

resource "aws_ec2_tag" "vpc_tag" {
  resource_id = var.vpc_id
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "private_subnet_tag" {
  for_each    = toset(var.subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "private_subnet_cluster_tag" {
  for_each    = toset(var.subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

#######################
# We will use only private subnets for nodes. 
# Uncomment this if you plan to use public subnets:

#resource "aws_ec2_tag" "public_subnet_tag" {
#  for_each    = toset(var.public_subnets)
#  resource_id = each.value
#  key         = "kubernetes.io/role/elb"
#  value       = "1"
#}

#resource "aws_ec2_tag" "public_subnet_cluster_tag" {
#  for_each    = toset(var.public_subnets)
#  resource_id = each.value
#  key         = "kubernetes.io/cluster/${var.cluster_name}"
#  value       = "shared"
#}
#######################
