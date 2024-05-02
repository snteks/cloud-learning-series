include "provider" {
  path   = find_in_parent_folders("./.global/iac/provider.hcl")
  expose = "true"
}

include "remote_state" {
  path   = find_in_parent_folders("./.global/iac/remote_state.hcl")
  expose = "true"
}

locals {
  context = yamldecode(include.provider.generate.context.contents)
  path    = find_in_parent_folders("./composite")
  name    = "${local.context.system_name}-${local.context.sub_system_name}-${local.context.stack_name}-${local.context.environment}"
}


terraform {
  source = "${local.path}//"
}

inputs = {
  context                              = local.context
  application                          = "${local.context.stack_name}"
  cluster_name                         = "${local.name}-cluster"
  kms_key_description                  = "EKS KMS key for ${local.name}"
  kms_key_name                         = "alias/${local.name}-kms-key1"
  eks_iam_name                         = "SNTEKS-${local.name}-cluster_role"
  sg_name                              = "${local.name}-sg"
  sg_description                       = "security group for ${local.name}"
  vpc_id                               = "vpc-036c307b9de2b3a0f"
  ingress_rules                        = ["https-443-tcp"]
  ingress_cidr_blocks                  = ["10.0.0.0/8"]
  cluster_security_group_id            = []
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  parameterstore_clustername           = "${local.name}-cluster_name"
  pdo_string                           = "SNTEKS"
  cluster_version                      = 1.28
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_subnets = [
    "subnet-0edd1ccceb9a81448",
    "subnet-0218449d03cd2b872",
    "subnet-0119c1d8bdc09ea5f",
    "subnet-029d1780dfe2fce64",

    "subnet-043fb65e08e03861d",
    "subnet-0820a6f362281eb9c",

    "subnet-0d0c276cca5463cf9",
    "subnet-0d3355f2662245a25",
    "subnet-081347443fb553570",
    "subnet-0ea33bdd49eb20e05"
  ]
  fargate_profile_list = <<EOF
{
    "core": {
        "name": "core",
        "iam_name": "SNTEKS-${local.name}-core_fargate_role",
        "iam_trusted_entities_list": [
            {
                "type": "Service",
                "identifier": [
                    "eks-fargate-pods.amazonaws.com"
                ]
            }
        ],
        "iam_managed_policy_arns": [
            "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
        ],
        "iam_inline_policy_name": "SNTEKS-EKSpodexecutioninlinepolicy",
        "iam_inline_policies_list": [],
        "subnets": [
            
            "subnet-043fb65e08e03861d",
            "subnet-0820a6f362281eb9c"
        ],
        "selectors": [
            {
                "namespace": "*core*"
            },
            {
                "namespace": "argocd"
            },
            {
                "namespace": "kube-system"
            },
            {
                "namespace": "default"
            },
            {
                "namespace": "*"
            }
        ]
    },
    "web": {
        "name": "web",
        "iam_name": "SNTEKS-${local.name}-web_fargate_role",
        "iam_trusted_entities_list": [
            {
                "type": "Service",
                "identifier": [
                    "eks-fargate-pods.amazonaws.com"
                ]
            }
        ],
        "iam_managed_policy_arns": [
            "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
        ],
        "iam_inline_policy_name": "SNTEKS-EKSpodexecutioninlinepolicy",
        "iam_inline_policies_list": [],
        "subnets": [
            "subnet-0edd1ccceb9a81448",
            "subnet-0218449d03cd2b872",
            "subnet-0119c1d8bdc09ea5f",
            "subnet-029d1780dfe2fce64"
        ],
        "selectors": [
            {
                "namespace": "*web*"
            }
        ]
    },
    "app": {
        "name": "app",
        "iam_name": "SNTEKS-${local.name}-app_fargate_role",
        "iam_trusted_entities_list": [
            {
                "type": "Service",
                "identifier": [
                    "eks-fargate-pods.amazonaws.com"
                ]
            }
        ],
        "iam_managed_policy_arns": [
            "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
        ],
        "iam_inline_policy_name": "SNTEKS-EKSpodexecutioninlinepolicy",
        "iam_inline_policies_list": [],
        "subnets": [
            
            "subnet-043fb65e08e03861d",
            "subnet-0820a6f362281eb9c"
        ],
        "selectors": [
            {
                "namespace": "*app*"
            }
        ]
    },
    "data": {
        "name": "data",
        "iam_name": "SNTEKS-${local.name}-data_fargate_role",
        "iam_trusted_entities_list": [
            {
                "type": "Service",
                "identifier": [
                    "eks-fargate-pods.amazonaws.com"
                ]
            }
        ],
        "iam_managed_policy_arns": [
            "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
        ],
        "iam_inline_policy_name": "SNTEKS-EKSpodexecutioninlinepolicy",
        "iam_inline_policies_list": [],
        "subnets": [
            "subnet-0d0c276cca5463cf9",
            "subnet-0d3355f2662245a25",
            "subnet-081347443fb553570",
            "subnet-0ea33bdd49eb20e05"
        ],
        "selectors": [
            {
                "namespace": "*data*"
            }
        ]
    }
}
EOF
}
