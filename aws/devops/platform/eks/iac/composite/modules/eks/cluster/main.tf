## ---------------------------------------------------------------------------------------------------------------------
## KMS RESOURCES
## Creates KMS resources for EKS cluster
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "eks" {
  description         = var.kms_key_description
  policy              = data.aws_iam_policy_document.kms_policy_document.json
  enable_key_rotation = true
}

resource "aws_kms_alias" "custom_key_alias" {
  name          = var.kms_key_name
  target_key_id = aws_kms_key.eks.key_id
}

data "aws_iam_policy_document" "kms_policy_document" {
  dynamic "statement" {
    for_each = var.kms_policies_list
    content {
      principals {
        type        = statement.value["type"]
        identifiers = statement.value["identifier"]
      }
      sid       = statement.value["sid"]
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
      condition {
        test     = statement.value["query"]
        variable = statement.value["var"]
        values   = statement.value["reg"]
      }
    }
  }
}

## ---------------------------------------------------------------------------------------------------------------------
## SECURITY GROUP RESOURCES
## Creates Security Group for EKS cluster
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "create_sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
  tags        = var.sg_tags
}


resource "aws_security_group_rule" "defined_ingress_rules" {
  count             = length(var.ingress_rules)
  security_group_id = aws_security_group.create_sg.id
  description       = var.rules[var.ingress_rules[count.index]][3]
  type              = "ingress"
  from_port         = var.rules[var.ingress_rules[count.index]][0]
  to_port           = var.rules[var.ingress_rules[count.index]][1]
  protocol          = var.rules[var.ingress_rules[count.index]][2]
  cidr_blocks       = var.ingress_cidr_blocks
}

resource "aws_security_group_rule" "ingress_rules" {
  count             = length(var.ingress_with_cidr_blocks)
  security_group_id = aws_security_group.create_sg.id
  type              = "ingress"
  cidr_blocks = split(
    ",",
    lookup(
      var.ingress_with_cidr_blocks[count.index],
      "cidr_blocks",
      join(",", var.ingress_cidr_blocks),
    ),
  )
  description = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "description",
    "Ingress Rule",
  )

  from_port = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][2],
  )
}

resource "aws_security_group_rule" "egress_with_cidr_blocks" {
  count = length(var.egress_with_cidr_blocks)

  security_group_id = aws_security_group.create_sg.id
  type              = "egress"
  cidr_blocks = split(
    ",",
    lookup(
      var.egress_with_cidr_blocks[count.index],
      "cidr_blocks",
      join(",", var.egress_cidr_blocks),
    ),
  )
  description = lookup(
    var.egress_with_cidr_blocks[count.index],
    "description",
    "Egress Rule",
  )
  from_port = lookup(
    var.egress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.egress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.egress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][2],
  )
}

resource "aws_security_group_rule" "egress_rules" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = var.security_group_rules_egress_cidr_list
  security_group_id = aws_security_group.create_sg.id
}


## ---------------------------------------------------------------------------------------------------------------------
## IAM RESOURCES
## Creates IAM resources for EKS Cluster
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "eks_cluster" {
  name = var.eks_iam_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

## Attach the necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name

}

resource "aws_iam_role_policy_attachment" "eks_vpc_resourcecontroller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}

## ---------------------------------------------------------------------------------------------------------------------
## EKS CLUSTER RESOURCES
## Creates EKS Cluster resources
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_eks_cluster" "mycluster" {
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.eks_cluster.arn
  version                   = var.cluster_version
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  depends_on                = [aws_security_group.create_sg]
  vpc_config {
    security_group_ids      = var.cluster_security_group_id == null ? [aws_security_group.create_sg.id] : var.cluster_security_group_id
    subnet_ids              = var.cluster_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }
  kubernetes_network_config {}
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks.arn
    }
    resources = ["secrets"]
  }
  tags = var.eks_tags
}
## ---------------------------------------------------------------------------------------------------------------------
## EKS RBAC CONFIGURATION
## Creates EKS Cluster Roles
## ---------------------------------------------------------------------------------------------------------------------
resource "kubernetes_cluster_role" "cluster_role" {
  metadata {
    name = "eks-console-dashboard-full-access-clusterrole"
  }
  rule {
    api_groups = [""]
    resources  = [""]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  depends_on = [aws_eks_cluster.mycluster]
}
resource "kubernetes_cluster_role_binding" "cluster_role_binding" {
  metadata {
    name = "eks-console-dashboard-full-access-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cluster_role.metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = "eks-console-dashboard-full-access-group"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [aws_eks_cluster.mycluster]
}

## We are ignoring the data here since we will manage it with the resource below
provider "kubernetes" {
  host                   = aws_eks_cluster.mycluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.mycluster.certificate_authority[0].data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", aws_eks_cluster.mycluster.id]
    
  }
}



resource "kubernetes_config_map" "aws_auth" {

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  depends_on = [aws_eks_cluster.mycluster]
  lifecycle {
    ignore_changes = [data]
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth" {

  force = true
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles    = yamlencode(var.map_roles)
    mapUsers    = yamlencode(var.map_users)
    mapAccounts = yamlencode(var.map_accounts)
  }
  depends_on = [kubernetes_config_map.aws_auth]
}







