resource "aws_iam_role" "pipeline" {
  assume_role_policy  = data.aws_iam_policy_document.asume_role_policy.json
  name                = "PipelineRole"
  managed_policy_arns = [module.pipeline_policy.output.policy_arn]
}

module "pipeline_policy" {
  source = "../modules/iam-policy"

  policy_name        = "PipelinePolicy"
  policy_description = "Policy for pipeline role"
  statements         = [
    {
      sid        = "Alloweks"
      effect     = "Allow"
      actions    = [               
        "eks:DescribeCluster",
        "eks:ListClusters"
      ]
      resources  = ["*"]
    },
    {
      sid     = "PipelineAllowUseOfEcr"
      effect  = "Allow"
      actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:ListTagsForResource",
        "ecr:DescribeImageScanFindings",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ]
      resources = ["*"]
    }
  ]
}


resource "aws_iam_openid_connect_provider" "github" {
  client_id_list  = ["https://github.com/${var.github_org}"]
  thumbprint_list = [var.github_thumbprint]
  url             = var.github_token_url
}


data "aws_iam_policy_document" "asume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.github.url, "https://", "")}:sub"
      values   = ["repo:${var.github_org}/*"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.github.arn]
      type        = "Federated"
    }
  }
}

