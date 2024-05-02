locals {
  #enabled                       = module.this.enabled
  parameter_write               = var.enabled && ! var.ignore_value_changes ? { for e in var.parameter_write : e.name => merge(var.parameter_write_defaults, e) } : {}
  #parameter_write_ignore_values = var.enabled && var.ignore_value_changes ? { for e in var.parameter_write : e.name => merge(var.parameter_write_defaults, e) } : {}
  #parameter_read                = local.enabled ? var.parameter_read : []
}


resource "aws_ssm_parameter" "myparameter" {
  for_each = local.parameter_write
  name     = each.key

  description     = each.value.description
  type            = each.value.type
  tier            = each.value.tier
  #key_id          = each.value.type == "SecureString" && length(var.kms_arn) > 0 ? var.kms_arn : ""
  value           = each.value.value
  overwrite       = true
  #allowed_pattern = each.value.allowed_pattern
  data_type       = each.value.data_type

  #tags = module.this.tags
}
