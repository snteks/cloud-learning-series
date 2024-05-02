# ---------------------------------------------------------------------------------------------------------------------
# AWS IAM POLICY DOCUMENT FOR ASSUMING ROLE
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "iam_role" {
  name                 = "${var.iam_prefix}-${var.name}-role"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.iam_permissions_boundary}"
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS IAM POLICY ATTACHMENT FOR SECRETS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_policy_attachment" "secrets_policy_attachment" {
  name       = "${var.name}-policy-attachment"
  policy_arn = aws_iam_policy.iam-secrets_policy.arn
  roles      = [aws_iam_role.iam_role.name]
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS IAM OPENID CONNECT PROVIDER FOR CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS IAM POLICY FOR SECRETS MANAGEMENT
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "iam-secrets_policy" {
  name = "${var.name}-ssm"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "ssm:DescribeParameters",
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParametersByPath"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    }
  )
}
