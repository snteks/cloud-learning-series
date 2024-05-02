# ---------------------------------------------------------------------------------------------------------------------
# HELM RELEASE
# ---------------------------------------------------------------------------------------------------------------------

module "helm_release" {
  source             = "./modules/argocd/"
  cluster_name       = var.cluster_name
  subnets            = var.subnets
  vpc_id             = var.vpc_id
  chart_version      = "5.19.14"
  chart_name         = "argo-cd"
  chart_repo_url     = "https://argoproj.github.io/argo-helm"
  chart_namespace    = "argocd"
  chart_release_name = "argocd"
  replicas           = var.replicas

}
