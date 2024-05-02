data "aws_caller_identity" "current" {}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.create_namespace
  }
  depends_on = [data.aws_eks_cluster_auth.mycluster]
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

