# data "aws_eks_cluster_auth" "mycluster" {
#   name = aws_eks_cluster.mycluster.name
# }

output "cluster_name" {
  value = aws_eks_cluster.mycluster.name
}


output "endpoint" {
  value = aws_eks_cluster.mycluster.endpoint
}

output "clustercert" {
  value = aws_eks_cluster.mycluster.certificate_authority[0].data
}

