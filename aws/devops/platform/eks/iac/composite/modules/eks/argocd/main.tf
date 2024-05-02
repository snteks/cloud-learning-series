# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     name = var.create_namespace
#   }
# }


resource "helm_release" "argocd" {
#   depends_on = [
#     kubernetes_namespace.argocd
#   ]
  repository       = var.repourl
  chart            = var.chart_name
  version          = var.chartversion
  name             = var.helm_release_name
  namespace        = var.chart_namespace
  create_namespace = true
  values = [
    <<EOL
      server:
        replicas: 2
EOL
    ,
  ]
}



