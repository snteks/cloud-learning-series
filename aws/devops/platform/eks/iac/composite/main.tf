locals {
  name = "${var.context.system_name}-${var.context.sub_system_name}-${var.context.stack_name}-${var.context.environment}"
}
data "aws_caller_identity" "current" {}

module "eks_cluster" {
  source                               = "./modules/eks/cluster"
  cluster_name                         = var.cluster_name
  kms_key_description                  = var.kms_key_description
  kms_key_name                         = var.kms_key_name
  cluster_version                      = var.cluster_version
  cluster_security_group_id            = var.cluster_security_group_id
  eks_iam_name                         = var.eks_iam_name
  sg_name                              = var.sg_name
  sg_description                       = var.sg_description
  vpc_id                               = var.vpc_id
  ingress_rules                        = var.ingress_rules
  ingress_cidr_blocks                  = var.ingress_cidr_blocks
  egress_with_cidr_blocks              = var.egress_with_cidr_blocks
  cluster_subnets                      = var.cluster_subnets
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  wait_for_fargate_profile_deletion    = true
  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SNTEKS-${var.pdo_string}-ADMIN-${upper(var.context.environment)}"
      username = "SNTEKS-${var.pdo_string}-ADMIN-${upper(var.context.environment)}"
      groups = [
        "system:masters",
        "eks-console-dashboard-full-access-group"
      ]
    },
    {
      rolearn  = "${data.aws_caller_identity.current.arn}"
      username = "SNTEKS-${var.pdo_string}-ADMIN-${upper(var.context.environment)}"
      groups = [
        "system:masters",
        "eks-console-dashboard-full-access-group"
      ]
    },
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SNTEKS-${local.name}-core_fargate_role"
      username = "system:node:{{SessionName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
        "system:node-proxier",
        "system:*"
      ]
    },
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SNTEKS-${local.name}-web_fargate_role"
      username = "system:node:{{SessionName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
        "system:node-proxier",
        "system:*"
      ]
    },
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SNTEKS-${local.name}-app_fargate_role"
      username = "system:node:{{SessionName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
        "system:node-proxier",
        "system:*"
      ]
    },
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SNTEKS-${local.name}-data_fargate_role"
      username = "system:node:{{SessionName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
        "system:node-proxier",
        "system:*"
      ]
    },
  ]
  map_accounts = [
    "${data.aws_caller_identity.current.account_id}"
  ]
  kms_policies_list = [
    {
      type       = "AWS"
      identifier = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      sid        = "Enable IAM User Permissions"
      actions = [
        "kms:*"
      ]
      resources = ["*"]
      query     = "StringEquals"
      var       = "aws:RequestedRegion"
      reg       = ["us-east-1"]
    },
    {
      type       = "AWS"
      identifier = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      sid        = "Allow access for all principals in the account that are authorized"
      actions = [
        "kms:*"
      ]
      resources = ["*"]
      query     = "StringEquals"
      var       = "eks.us-east-1.amazonaws.com"
      reg       = ["${data.aws_caller_identity.current.account_id}"]
    }
  ]
}



resource "null_resource" "wait_for_cluster" {
  triggers = {
    cluster_id = module.eks_cluster.cluster_name
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }
}

module "fargate_profile" {
  depends_on           = [null_resource.wait_for_cluster]
  source               = "./modules/eks/fargate"
  cluster_name         = module.eks_cluster.cluster_name
  fargate_profile_list = jsondecode(var.fargate_profile_list)
}

module "addons" {
  source               = "./modules/eks/addons"
  depends_on           = [module.fargate_profile]
  aws_eks_cluster_name = module.eks_cluster.cluster_name
  cluster_addons = {
    kube-proxy = {
      most_recent = true
      preserve    = true
    },
    vpc-cni = {
      most_recent = true
    }
  }
}

# module "oidc" {
#   source            = "./modules/eks/oidc"
#   depends_on        = [module.addons]
#   cluster_name      = module.eks_cluster.cluster_name
# }
