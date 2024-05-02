include "provider" {
  path   = find_in_parent_folders("./.global/iac/provider.hcl")
  expose = "true"
}

include "remote_state" {
  path   = find_in_parent_folders("./.global/iac/remote_state.hcl")
  expose = "true"
}

locals {
  context = yamldecode(include.provider.generate.context.contents)
  path    = find_in_parent_folders("./composite")
}



terraform {
  source = "${local.path}//terraform"
}


inputs = {
  cluster_name = "${local.context.system_name}-${local.context.sub_system_name}-eks-${local.context.environment}-cluster"
  vpc_id       = "vpc-036c307b9de2b3a0f"
  subnets = [
    "subnet-04c3d63ee9c4d7e03",
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
  replicas = "1"
}





