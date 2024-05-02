<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
## Requirements

No requirements.
## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_eks_cluster.mycluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.mycluster1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
## Example
```hcl
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

```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | n/a | `string` | n/a | yes |
| <a name="input_chart_namespace"></a> [chart\_namespace](#input\_chart\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_chartversion"></a> [chartversion](#input\_chartversion) | n/a | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | n/a | `string` | n/a | yes |
| <a name="input_myparameter_name"></a> [myparameter\_name](#input\_myparameter\_name) | Name of the SSM parameter | `string` | `"myclusternamestore"` | no |
| <a name="input_repourl"></a> [repourl](#input\_repourl) | n/a | `string` | n/a | yes |
## Outputs

No outputs.

```
<!-- END_TF_DOCS -->