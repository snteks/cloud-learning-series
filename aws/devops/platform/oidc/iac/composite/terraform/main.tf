locals {
  name = "${var.context.system_name}-${var.context.sub_system_name}-${var.context.stack_name}-${var.context.environment}"
}


module "oidc" {
  source                   = "./modules/oidc/"
  cluster_name             = var.cluster_name
  name                     = local.name
  iam_permissions_boundary = var.iam_permissions_boundary
  iam_prefix               = var.iam_prefix
}
