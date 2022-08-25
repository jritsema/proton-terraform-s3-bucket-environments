# This identity provider is required to accept OpenID Connect credentials
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions_oidc_provider.certificates[0].sha1_fingerprint]
}

# the role that the github action runs as
resource "aws_iam_role" "github_actions" {
  name               = var.namespace
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  inline_policy {
    name = "github-action-policy"

    policy = jsonencode({
      Statement = [
        {
          Effect   = "Allow"
          Action   = ["proton:NotifyResourceDeploymentStatusChange"]
          Resource = "arn:aws:proton:us-east-1:921157608237:environment/*"
        },
      ]
    })
  }
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
    }
  }
}
