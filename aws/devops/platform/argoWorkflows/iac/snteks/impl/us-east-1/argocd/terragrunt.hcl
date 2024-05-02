

include "provider" {
   path = find_in_parent_folders("./.global/iac/provider.hcl")
   expose = "true"
}

include "remote_state" {
   path = find_in_parent_folders("./.global/iac/remote_state.hcl")
   expose = "true"
}

locals {
  context = yamldecode(include.provider.generate.context.contents)
  path = find_in_parent_folders("./modules")
  name    = "${local.context.system_name}-${local.context.sub_system_name}-eks-${local.context.environment}"
}



terraform {
  source = "${local.path}//composite/argocd"
  #source = "../../../modules/composite/argocd/"
}


inputs = {
  context = local.context
  cluster_name                         = "${local.name}-cluster"
  environment                          =  "impl"
  chartversion                         =  "5.19.14"
  chart_name                           =  "argo-cd"
  repourl                              =  "https://argoproj.github.io/argo-helm"
  create_namespace                     =  "argocd"
  chart_namespace                      =  "argocd"
  helm_release_name                    =  "argocd"
  vpc_id                               =  "vpc-0299493932dd312fe" 
  #context = local.context 
  aws_region             = "us-east-1"
  subnets                = [ 
    "subnet-01f20ab9c7caa324d",
    "subnet-081cb2b63eb0a73cf",
    "subnet-0060223d9cab9d116",
    "subnet-0be543014fad83f7c",

    "subnet-0842972aac328914c",
    "subnet-07d8f905439bb8274",
    "subnet-0ac144b4df1c2f271",
    "subnet-0e76a277ab77b3570",

    "subnet-095bc87e642605999",
    "subnet-03826cf37afd693d8",
    "subnet-0a240d7f162d9a15d",
    "subnet-0c845496fc547b8c0"
                           
                           ]
  port                   = 8443
  certificate_arn        = "arn:aws:acm:us-east-1:216666615333:certificate/26bde0bc-b189-4681-ad18-579878f5a9ff"
}
  




