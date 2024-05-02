locals {
  create_inline_policy = length(var.inline_policies_list) > 0 ? true : false
  #create_custom_policy = length(var.custom_policies_list) > 0 ? true : false
  #role_sts_externalid = flatten([var.role_sts_externalid])
  #role_condition = flatten([var.role_condition])

 # inline_policy_condition = flatten([var.inline_condition])

}


data "aws_iam_policy_document" "assume-role-policy_document" {
    dynamic "statement" {
        for_each = var.trusted_entities_list
        content {
            actions = ["sts:AssumeRole"]
            principals {
                type = statement.value["type"]
                identifiers = statement.value["identifier"]
            }
        }
    }
}


data "aws_iam_policy_document" "inline_policy_document" {
    dynamic "statement" {
        for_each = var.inline_policies_list
        content {
            sid = statement.value["sid"]
            actions = statement.value["actions"]
            resources = statement.value["resources"]
            #effect = statement.value["effect_type"]
       # }
        #dynamic "condition" {
        #	for_each = length(local.inline_policy_condition) != 0 ? [true] : []
        condition {
            test = statement.value["query"]
            variable = statement.value["var"]
            values = statement.value["reg"]
            }
            
       # }
}
    }
}

/*
resource "aws_iam_policy" "example" {
  name   = var.custompolicy_name
  path   = "/"
  policy = "${file(var.file_name)}"
}*/
/*
resource "aws_iam_policy" "example" {
  #count = var.custom_policy == "yes" ? 1 : 0
  name   = var.custompolicy_name
  path   = "/"
  policy = data.aws_iam_policy_document.custom_policy_document.json
}

data "aws_iam_policy_document" "custom_policy_document" {
  dynamic statement {
    for_each = var.custom_policies_list
        content {
            sid = statement.value["custom_sid"]
            actions = statement.value["custom_actions"]
            resources = statement.value["custom_resources"]
            effect = statement.value["custom_effect_type"]

        condition {

            test = statement.value["custom_query"]
            variable = statement.value["custom_var"]
            values = statement.value["custom_reg"]
            }
    
  }
}
  }*/

data "aws_caller_identity" "current" {}




resource "aws_iam_role" "iam_role" {
    name = var.name
    permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.iam_permission_boundary}"
    assume_role_policy = data.aws_iam_policy_document.assume-role-policy_document.json
    #managed_policy_arns = [ aws_iam_policy.example.arn ]
    managed_policy_arns = var.managed_policy_arns
    dynamic inline_policy {
        for_each = local.create_inline_policy == true ? [1] : []
        content {
            name   = var.inline_policy_name
            policy = data.aws_iam_policy_document.inline_policy_document.json
        }
    }
    tags = {
        Type = "Self Service"
    }
}

/*
resource "aws_iam_role" "iam_role" {
    name = var.name
    permissions_boundary = "arn:aws:iam::${var.aws_account_id}:policy/${var.iam_permission_boundary}"
    assume_role_policy = data.aws_iam_policy_document.assume-role-policy_document.json
    #managed_policy_arns = [ aws_iam_policy.example.arn ]
    #aws_iam_policy.example
    dynamic inline_policy {
        for_each = local.create_inline_policy == true ? [1] : []
        content {
            name   = var.inline_policy_name
            policy = data.aws_iam_policy_document.inline_policy_document.json
        }
    }
    tags = {
        Type = "Self Service"
    }
}*/


