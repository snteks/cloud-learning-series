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
}


terraform {
  source = "${local.path}//composite"
}


inputs = {
  context = local.context
}


