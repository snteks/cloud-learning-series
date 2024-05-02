variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
  type        = any
  default     = {}
}

variable "cluster_addons_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster addons"
  type        = map(string)
  default     = {}
}

variable "aws_eks_cluster_name" {
  type        = string
  description = " The cluster name to be used to add fargate roles"
  default     = ""
}

variable "create_outposts_local_cluster" {
  type    = bool
  default = false
}

variable "create" {
  type        = bool
  default     = true
}
