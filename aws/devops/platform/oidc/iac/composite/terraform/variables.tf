## ---------------------------------------------------------------------------------------------------------------------
## ENVIRONMENT VARIABLES
## Define these secrets as environment variables
## ---------------------------------------------------------------------------------------------------------------------



## ---------------------------------------------------------------------------------------------------------------------
## MODULE PARAMETERS
## These variables are expected to be passed in by the operator
## ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "context" {
  type        = map(any)
  description = "Context Variables"
}

variable "iam_permissions_boundary" {
  type        = string
  description = "Name of the IAM permissions boundary"
}

variable "iam_prefix" {
  type        = string
  description = "Name of the IAM prefix"
}

## ---------------------------------------------------------------------------------------------------------------------
## OPTIONAL PARAMETERS
## These variables have defaults and may be overridden
## ---------------------------------------------------------------------------------------------------------------------
