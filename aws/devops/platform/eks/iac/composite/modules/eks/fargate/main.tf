data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}
data "aws_caller_identity" "current" {}
# provider "kubernetes" {
#   host                   = aws_eks_cluster.mycluster.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.mycluster.certificate_authority[0].data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     # This requires the awscli to be installed locally where Terraform is executed
#     args = ["eks", "get-token", "--cluster-name", var.aws_eks_cluster.mycluster.id]
#   }
# }


resource "aws_eks_fargate_profile" "fargate-profile" {
  for_each               = var.fargate_profile_list
  cluster_name           = var.cluster_name
  fargate_profile_name   = each.value.name
  pod_execution_role_arn = module.fargate_iam["${each.key}"].role_arn
  subnet_ids             = each.value.subnets


  dynamic "selector" {
    for_each = each.value.selectors

    content {
      namespace = selector.value.namespace
      labels    = lookup(selector.value, "labels", {})
    }
 }

  dynamic "timeouts" {
    for_each = [var.timeouts]
    content {
      create = lookup(var.timeouts, "create", null)
      delete = lookup(var.timeouts, "delete", null)
    }
  }
}


module "fargate_iam" {
  source                = "./modules/iam/role-without-condition"
  for_each              = var.fargate_profile_list
  name                  = each.value.iam_name
  trusted_entities_list = each.value.iam_trusted_entities_list
  managed_policy_arns   = each.value.iam_managed_policy_arns
  inline_policy_name    = each.value.iam_inline_policy_name
  inline_policies_list  = each.value.iam_inline_policies_list
}


# resource "null_resource" "kubectl" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     command = <<EOF
#         aws eks --region us-east-1 update-kubeconfig --name ${aws_eks_cluster.mycluster.id}
#         annotation_value=$(kubectl get deployment -n kube-system "coredns" -o jsonpath="{.spec.template.metadata}" | grep eks.amazonaws.com/compute-type)

#         if [ -z "$annotation_value" ]; then
#         echo "EC2 not set for deployment"
#         else
#         echo "Removing annotation from deployment"
#         kubectl patch deployment coredns -n kube-system --type=json -p='[{"op": "remove", "path": "/spec/template/metadata/annotations", "value": "eks.amazonaws.com/compute-type"}]'
#         kubectl rollout restart -n kube-system deployment coredns
#         while [[ $(kubectl get deployment -n kube-system coredns -o 'jsonpath={..status.conditions[?(@.type=="Available")].status}') != "True" ]]; do
#         echo "Waiting for the deployment to be ready..."
#         sleep 5
#         done
#         echo "Deployment is now ready"
#         fi
#     EOF
#   }
#   depends_on = [aws_eks_fargate_profile.fargate-profile]
# }
