data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  name = "${var.context.system_name}-${var.context.sub_system_name}-${var.context.stack_name}-${var.context.environment}"
}


module "ecs_cluster" {
  source       = "./modules/ecs/cluster"
  cluster_name = "${local.name}"
}

resource "aws_ssm_parameter" "cluster_name" {
  name        = "${local.name}-cluster-name"
  description = "cluster_name"
  type        = "String"
  value       = module.ecs_cluster.fargate_cluster_name
}

resource "aws_ssm_parameter" "cluster_id" {
  name        = "${local.name}-cluster-id"
  description = "cluster_id"
  type        = "String"
  value       = module.ecs_cluster.fargate_cluster_id
}