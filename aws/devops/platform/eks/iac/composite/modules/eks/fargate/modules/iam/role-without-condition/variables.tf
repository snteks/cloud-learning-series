variable "name" {}
//variable "aws_account_id" {}
variable "iam_permission_boundary" {
  default = "SNTEKS-PermissionBoundary-V2"
}
variable "path" {
  type    = string
  default = "/delegatedadmin/developer/"
}
variable "trusted_entities_list" {
  type    = list(any)
  default = []
}
variable "inline_policies_list" {
  type    = list(any)
  default = []
}

variable "custom_policies_list" {
  type    = list(any)
  default = []

}

variable "custompolicy_name" {
  type    = string
  default = ""

}
variable "managed_policy_arns" {
  type    = list(any)
  default = []
}
variable "inline_policy_name" {
  default = "inline_policy_default"
}
