
locals {
  account_id      = get_aws_account_id()
  region          = yamldecode(file(find_in_parent_folders("region.yaml"))).region
  system_name     = yamldecode(file(find_in_parent_folders("system.yaml"))).system_name
  sub_system_name = yamldecode(file(find_in_parent_folders("sub_system.yaml"))).sub_system_name
  stack_name      = yamldecode(file(find_in_parent_folders("stack.yaml"))).stack_name
  environment     = yamldecode(file(find_in_parent_folders("environment.yaml"))).environment


}

remote_state {
  backend = "s3"
  config = {
    encrypt               = true
    bucket                = "${local.account_id}-cicd-gha-runner-cloud-bootstrap-prod-tf-state"
    key                   = "${local.system_name}-${local.sub_system_name}-${local.stack_name}-${local.environment}"
    region                = local.region
    dynamodb_table        = "${local.system_name}-${local.sub_system_name}-${local.stack_name}-${local.environment}"
    disable_bucket_update = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
