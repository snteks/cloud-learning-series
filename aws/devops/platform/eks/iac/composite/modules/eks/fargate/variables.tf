variable "cluster_name" {
  type        = string
  description = " The cluster name to be used to add fargate roles"
  default     = ""
}
variable "timeouts" {
  description = "Create and delete timeout configurations for the Fargate Profile"
  type        = map(string)
  default     = {}
}
variable "fargate_profile_list" {
  type        = map(any)
  description = "List of fargate profiles"
  default     = {}
}
