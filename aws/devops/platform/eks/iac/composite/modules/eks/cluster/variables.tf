## ---------------------------------------------------------------------------------------------------------------------
## MODULE PARAMETERS
## These variables have defaults and may be overridden
## ---------------------------------------------------------------------------------------------------------------------
variable "cluster_name" {
  type        = string
  description = " The cluster name to be used by default"
}

variable "sg_description" {
  type        = string
  description = "The purpose of the security group created for Kubernetes cluster"
}

variable "vpc_id" {
  type        = string
  description = "The VPC used to create Kubernetes cluster resources"
}

variable "sg_name" {
  type        = string
  description = "Name of the security group created for Kubernetes cluster"
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
variable "cluster_endpoint_private_access" {
  description = "enable or disable cluster endpoint priviate access"
  type        = string
}
variable "cluster_endpoint_public_access" {
  description = "enable or disable cluster endpoint public access"
  type        = string
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "The CIDR range to create cluster public endpoint"
}

variable "cluster_security_group_id" {
  type        = list(any)
  description = "The security group attached to cluster"
}

## ---------------------------------------------------------------------------------------------------------------------
## OPTIONAL PARAMETERS
## These variables are expected to be passed in by the operator
## ---------------------------------------------------------------------------------------------------------------------

variable "cluster_version" {
  description = "The Kubernetes version used"
  default     = "1.25"
}

variable "eks_tags" {
  type        = map(any)
  description = "The tags used in Kuberentes cluster"
  default     = {}
}

variable "wait_for_fargate_profile_deletion" {
  description = " enable or disable fargate profile deletion for terraform destroy"
  type        = bool
  default     = false
}

variable "sg_tags" {
  type        = map(any)
  description = "tags used on for Kubernetes cluster resources"
  default     = {}
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
variable "security_group_rules_egress_cidr_list" {
  description = "List of cidr ranges for egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
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

variable "parameter_write" {
  type        = list(map(string))
  description = "List of maps with the parameter values to write to SSM Parameter Store"
  default     = []
}
variable "parameter_write_defaults" {
  type        = map(any)
  description = "Parameter write default settings"
  default = {
    description     = null
    type            = "SecureString"
    tier            = "Standard"
    overwrite       = null
    value           = null
    allowed_pattern = null
    data_type       = "text"
  }
}

variable "enabled" {
  type    = bool
  default = true
}
variable "ignore_value_changes" {
  type        = bool
  description = "Whether to ignore future external changes in paramater values"
  default     = false
}
# variable "cluster_addons" {
#   description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
#   type        = any
#   default     = {}
# }
# variable "cluster_addons_timeouts" {
#   description = "Create, update, and delete timeout configurations for the cluster addons"
#   type        = map(string)
#   default     = {}
# }
variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth ConfigMap"
  type        = list(string)
  default     = []
}
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth ConfigMap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}
variable "map_users" {
  description = "Additional IAM users to add to the aws-auth ConfigMap"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "create_outposts_local_cluster" {
  type    = bool
  default = false
}

