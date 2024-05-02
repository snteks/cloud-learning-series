## ---------------------------------------------------------------------------------------------------------------------
## OIDC RESOURCES
## Creates OIDC resources for EKS cluster
## ---------------------------------------------------------------------------------------------------------------------
data "aws_eks_cluster" "mycluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "mycluster1" {
  name = var.cluster_name
}
data "tls_certificate" "cluster" {
  url = data.aws_eks_cluster.mycluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.cluster.certificates.0.sha1_fingerprint])
  url             = data.aws_eks_cluster.mycluster.identity.0.oidc.0.issuer
}
