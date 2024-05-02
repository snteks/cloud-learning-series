# ---------------------------------------------------------------------------------------------------------------------
# KUBERNETES NAMESPACE
# ---------------------------------------------------------------------------------------------------------------------

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.chart_namespace
  }
  depends_on = [data.aws_eks_cluster_auth.eks_cluster]
}

# ---------------------------------------------------------------------------------------------------------------------
# HELM RELEASE
# ---------------------------------------------------------------------------------------------------------------------

resource "helm_release" "argocd" {
  repository = var.chart_repo_url
  chart      = var.chart_name
  version    = var.chart_version
  name       = var.chart_release_name
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  values     = [
    <<EOL
      server:
        replicas: ${var.replicas}
    EOL
  ]

  depends_on = [kubernetes_namespace.argocd]
}
