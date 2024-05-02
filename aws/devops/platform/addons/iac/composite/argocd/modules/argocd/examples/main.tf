data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-east-1"
}


# #Argocd install thru helm chart

 module "helm_release" {
   source   = "./../"
  # parameterstore_clustername = var.cluster_name
   cluster_name = var.cluster_name
   chartversion = "5.19.14"
   chart_name = "argo-cd"
   repourl = "https://argoproj.github.io/argo-helm"
   create_namespace = "argocd"
   chart_namespace = "argocd"
   helm_release_name = "argocd" 
 }

