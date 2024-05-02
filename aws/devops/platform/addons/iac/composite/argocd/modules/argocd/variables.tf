variable "chartversion" {
  type = string
 # default = "1.2"
}

variable "chart_name" {
  type = string
 # default = "argocd"
  
}

variable "repourl" {
    type = string
  #  default = "https://argoproj.github.io/argo-helm"
  
}

variable "create_namespace" {
  type = string
  #default = "argocd"
}
variable "chart_namespace" {
  type = string
 # default = "argocd"
}

variable "helm_release_name" {
  type = string
 # default = "argocd"
}

# variable "parameterstore_clustername" {
#   type = string
#   default = "cicd-k8s-portal-dev-cluster"
# }

variable "cluster_name" {
    type = string
   # default = "cicd-k8s-portal-dev-cluster"
}

variable "myparameter_name" {
  description = "Name of the SSM parameter"
  type        = string
  default = "myclusternamestore"
}

variable "app" {
  description = "Name of the app"
  type        = string
  default = " "
}
variable "vpc_id" {
  type        = string
  description = "The VPC used to create Kubernetes cluster resources"
}

variable "context" {
  type        = map
  description = "Context Variables"
}
variable "subnets" { type = list(any) }
variable "port" {}
variable "aws_region" {}
variable "certificate_arn" {}
variable "environment" {
  type        = string
  description = "The environment used to create Kubernetes cluster resources"
}
