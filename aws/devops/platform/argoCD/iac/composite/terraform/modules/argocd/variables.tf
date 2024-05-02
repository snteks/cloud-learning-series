## ---------------------------------------------------------------------------------------------------------------------
## ENVIRONMENT VARIABLES
## Define these secrets as environment variables
## ---------------------------------------------------------------------------------------------------------------------



## ---------------------------------------------------------------------------------------------------------------------
## MODULE PARAMETERS
## These variables are expected to be passed in by the operator
## ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
    type = string
}

variable "vpc_id" {
  type        = string
  description = "The VPC used to create Kubernetes cluster resources"
}

variable "subnets" {
  type        = list
  description = "The environment used to create Kubernetes cluster resources"
}

variable "chart_repo_url" {
  type        = string
  description = "Repository URL for the chart"
}

variable "chart_name" {
  type        = string
  description = "Chart name"
}

variable "chart_version" {
  type        = string
  description = "Chart version"
}

variable "chart_release_name" {
  type        = string
  description = "Name of the chart release"
}

variable "chart_namespace" {
  type        = string
  description = "Namespace for the chart"
}
## ---------------------------------------------------------------------------------------------------------------------
## OPTIONAL PARAMETERS
## These variables have defaults and may be overridden
## ---------------------------------------------------------------------------------------------------------------------

variable "replicas" {
  type        = string
  description = "how many replicas are needed for the pod"
  default = "1"
}