

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
  path = find_in_parent_folders("./composite")
  name    = "${local.context.system_name}-${local.context.sub_system_name}-eks-${local.context.environment}"
}



terraform {
  source = "${local.path}//argocd"
}


inputs = {
  context = local.context
  cluster_name                         = "${local.name}-cluster"
  environment                          =  "dev"
  chartversion                         =  "5.37.1"
  chart_name                           =  "argo-cd"
  repourl                              =  "https://argoproj.github.io/argo-helm"
  create_namespace                     =  "argocd"
  chart_namespace                      =  "argocd"
  helm_release_name                    =  "argocd"
  vpc_id                               =  "vpc-036c307b9de2b3a0f" 
  #context = local.context 
  aws_region             = "us-east-1"
  subnets                = ["subnet-04c3d63ee9c4d7e03", 
                            "subnet-09a0971509d581249",
                            "subnet-0edd1ccceb9a81448",
                            "subnet-0218449d03cd2b872",
                            "subnet-0119c1d8bdc09ea5f",
                             "subnet-029d1780dfe2fce64",

                            "subnet-09a0971509d581249",
                            "subnet-043fb65e08e03861d",
                            "subnet-04c3d63ee9c4d7e03",
                            "subnet-0820a6f362281eb9c",

            
                            "subnet-0d0c276cca5463cf9",
                            "subnet-0d3355f2662245a25",
                            "subnet-081347443fb553570",
                            "subnet-0ea33bdd49eb20e05"
                           
                           ]
  port                   = 8443
  certificate_arn        = "arn:aws:acm:us-east-1:853697862182:certificate/7f9b8925-66fe-4f4a-8f01-35340f0390c0"
}
  




