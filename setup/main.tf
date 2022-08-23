# the role that the github action runs as
resource "aws_iam_role" "github_actions" {
  name               = var.namespace
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  inline_policy {
    name = "proton"

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
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
    }
  }
}
