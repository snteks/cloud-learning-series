

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
  name    = "${local.context.system_name}-${local.context.sub_system_name}-eks-${local.context.environment}"
}



terraform {
  source = "${local.path}//terraform"
}


inputs = {
  context                  = local.context
  cluster_name             = "${local.name}-cluster"
  iam_permissions_boundary = "SNTEKS-PermissionBoundary-V2"
  iam_prefix               = "SNTEKS"

}
