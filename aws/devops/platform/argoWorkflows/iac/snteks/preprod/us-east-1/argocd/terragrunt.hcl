

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
  vpc_id                               =  "vpc-070fbc2b41fadf08b" 
  #context = local.context 
  aws_region             = "us-east-1"
  subnets                = [ 
    "subnet-03eb8327d65da263f",
    "subnet-06db3b90722bfe76e",
    "subnet-0fb2be378fc78f859"
    "subnet-02f2312cd110d3e06",

    "subnet-073255d0c935480a5",
    "subnet-089d5b42520af8650",
    "subnet-0a728da86c7d11071",
    "subnet-01dfffaac242bde25",

    "subnet-0abd458fda515ff92",
    "subnet-01014ac2ed0c5b9f9",
    "subnet-067bb5ace9d78437b",
    "subnet-0161ebf1ee81f6198"
                           
                           ]
  port                   = 8443
  certificate_arn        = "arn:aws:acm:us-east-1:094877685232:certificate/8410723b-e80f-438f-9389-0bd5ff298785"
}
  




