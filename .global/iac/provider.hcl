
locals {
  #  version         = yamldecode(file(find_in_parent_folders("version.yaml"))).version
  account_id      = get_aws_account_id()
  region          = yamldecode(file(find_in_parent_folders("region.yaml"))).region
  system_name     = yamldecode(file(find_in_parent_folders("system.yaml"))).system_name
  sub_system_name = yamldecode(file(find_in_parent_folders("sub_system.yaml"))).sub_system_name
  stack_name      = yamldecode(file(find_in_parent_folders("stack.yaml"))).stack_name
  environment     = yamldecode(file(find_in_parent_folders("environment.yaml"))).environment
  #  ignore_tags     = yamldecode(file(find_in_parent_folders("./.global/iac/ignore_tags.yaml"))).ignore_tags
  sub_layer_name  = try(yamldecode(file("${get_terragrunt_dir()}/sub_layer.yaml")).sub_layer, "")
}

generate "context" {
  path      = "context.yaml"
  if_exists = "overwrite"
  contents  = <<EOF
version:          ${local.version}
account_id:       ${local.account_id}
region:           ${local.region}
system_name:      ${local.system_name}
sub_system_name:  ${local.sub_system_name}
stack_name:       ${local.stack_name}
sub_layer_name:   ${local.sub_layer_name}
environment:      ${local.environment}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region = "${local.region}"
    profile =  "snteks"
    default_tags {
      tags = {
        system_name = "${local.system_name}"
        sub_system_name = "${local.sub_system_name}"
        stack_name = "${local.stack_name}"
        environment = "${local.environment}"
        version = "${local.version}"
        iac = "terraform"
      }
    }
    ignore_tags {
      keys =  ${jsonencode(local.ignore_tags)}
    }
  }
  EOF
}
