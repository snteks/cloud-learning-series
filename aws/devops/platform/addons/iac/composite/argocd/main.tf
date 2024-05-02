data "aws_caller_identity" "current" {}
locals {
  name = "${var.context.system_name}-${var.context.sub_system_name}-${var.context.stack_name}-${var.context.environment}"
  ssm_name = "${var.context.system_name}/${var.context.sub_system_name}/${var.context.stack_name}/${var.context.environment}"
}
module "helm_release" {
  #source   = "github.com/ccsq-qdas/terraform-modules/argocd"
   source   = "./modules/argocd/"
  #cluster_name = tostring(module.ssm.ssm_parameter_outputvalue.value)
  cluster_name  = var.cluster_name
  chartversion = var.chartversion
  chart_name = var.chart_name
  repourl = var.repourl
  create_namespace = var.create_namespace
  chart_namespace = var.chart_namespace
  helm_release_name = var.helm_release_name
  app               = var.app
  aws_region             = "us-east-1"
  subnets                = var.subnets
  vpc_id                 = var.vpc_id
  port                   = 8443
  certificate_arn        = var.certificate_arn
  context                = var.context
  environment            = var.environment
 }
/* 
 module "ingress_controller" {
  
  source   = "./modules/ingress-controller/"
  cluster_name           = var.cluster_name
  vpc_id                 = "vpc-036c307b9de2b3a0f"
  
}
*/



  


  
 
 