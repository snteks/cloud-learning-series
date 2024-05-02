variable "cluster_version" {
  description = "The Kubernetes version used"
  default     = "1.25"
}

variable "cluster_subnets" {
  description = "The subnets used in Kubernetes cluster"
  type        = list(any)

}

variable "eks_iam_name" {
  description = "IAM role used in Kubernetes cluster"
  type        = string

}

variable "kms_key_description" {
  description = "The description of KMS key used in Kubernetes cluster"
  type        = string
}

variable "kms_key_name" {
  description = "The KMS key used in Kubernetes cluster"
  type        = string
}

variable "kms_policies_list" {
  type        = list(any)
  description = "The Policies applied on kms"
  default     = []
}


# variable "cluster_encryptionkey_arn" {
#   description = "The encryption used in Kubernetes cluster"
#   type        = string
# }

variable "cluster_endpoint_private_access" {
  description = "enable or disable cluster endpoint priviate access"
  type        = string
}

variable "cluster_endpoint_public_access" {
  description = "enable or disable cluster endpoint public access"
  type        = string
}


variable "eks_tags" {
  type        = map(any)
  description = "The tags used in Kuberentes cluster"
  default     = {}
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "The CIDR range to create cluster public endpoint"
}
variable "wait_for_fargate_profile_deletion" {
  description = " enable or disable fargate profile deletion for terraform destroy"
  type        = bool
  default     = false
}

# fargate variables defined
variable "cluster_name" {
  type        = string
  description = " The cluster name to be used by default"
  default     = "snteks-dev"
}

# variable "fargate_profile_tags" {
#   type        = map(any)
#   description = " The tags to be used on fargate profile"
#   default     = {}

# }

# variable "fargate_profile_iam" {
#   type        = string
#   description = "The IAM role with sufficient previlages for fargate profile"

# }
# variable "fargate_profile_subnets" {
#   type        = list(any)
#   description = "The subnets used to create fargate profile"
#   default     = []
# }


# variable "fargate_profilename" {
#   type        = string
#   description = "The name used to create fargate profile"
#   default     = "snteks-dev-fargate-profile"
# }


# variable "selectors" {
#   description = "Configuration block(s) for selecting Kubernetes Pods to execute with this Fargate Profile"
#   type        = any
#   default = [
#     {
#       namespace = "github-runner"
#     },
#     {
#       namespace = "argocd"
#     },
#     {
#       namespace = "databricks"
#     },
#     {
#       namespace = "kube-system"
#     },
#     {
#       namespace = "default"
#     }
#   ]
# }

variable "timeouts" {
  description = "Create and delete timeout configurations for the Fargate Profile"
  type        = map(string)
  default     = {}
}




# security group variables

variable "sg_name" {
  type        = string
  description = "Name of the security group created for Kubernetes cluster"

}
variable "sg_tags" {
  type        = map(any)
  description = "tags used on for Kubernetes cluster resources"
  default     = {}
}

variable "sg_description" {
  type        = string
  description = "The purpose of the security group created for Kubernetes cluster"
}

variable "vpc_id" {
  type        = string
  description = "The VPC used to create Kubernetes cluster resources"
}

variable "ingress_rules" {
  description = "List of computed ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "egress_with_cidr_blocks" {
  type = list(object({
    cidr_blocks = string,
    description = string,
    from_port   = number,
    to_port     = number,
    protocol    = string
  }))
  default = [
    {
      rule        = "allow_https"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTPS traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    }
  ]
  description = "The outbound rules for security group"
}


variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = []
}

variable "cluster_security_group_id" {
  type        = list(any)
  description = "The security group attached to cluster"

}

# variable "chartversion" {
#   type        = string
#   description = "Helm chart version for Argocd"

# }

# variable "chart_name" {
#   type        = string
#   description = "Helm chart name for Argocd"


# }

# variable "repourl" {
#   type        = string
#   description = "Argocd project source for Helm"


# }

# variable "create_namespace" {
#   type        = string
#   description = "Namespace for Argocd"

# }
# variable "chart_namespace" {
#   type        = string
#   description = " Helm chart namespace for Argocd"

# }

# variable "helm_release_name" {
#   type        = string
#   description = "helm release name for Argocd"

# }

variable "parameterstore_clustername" {
  type        = string
  description = "parameter store to use any parameters for Argocd"

}


# variable "application" {


# }
#### SSM variables ########
# variable "clustername_store" {
#   default = "myclusternamestore"
# }

# variable "clustercert_store" {
#   default = "myclustercertstore"
# }

# variable "clusterendpoint_store" {
#   default = "myclusterendpointstore"
# }

# # variable "parameterstore_clustername" {

# # }

# variable "myparameter_name" {
#   description = "Name of the SSM parameter"
#   type        = string
#   default     = "myclusternamestore"
# }

##  Pod IAM  ##
# variable "pod_iam_name" {
#   type = string
# }

# variable "pod_trusted_entities_list" {
#   type    = list(any)
#   default = []
# }

# variable "pod_managed_policy_arns" {
#   type    = list(any)
#   default = []
# }
# variable "pod_inline_policy_name" {
#   default = "inline_policy_default"
# }
# variable "pod_inline_policies_list" {
#   type    = list(any)
#   default = []
# }

variable "pdo_string" {
  type    = string
  default = ""
}

variable "context" {
  type        = map(any)
  description = "Context Variables"
}

variable "fargate_profile_list" {
  type        = string
  description = "List of fargate profiles"
  default     = ""
}
