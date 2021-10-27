data "aws_iam_policy_document" "aws_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = var.trusted_identifier.type
      identifiers = var.trusted_identifier.identifiers
    }
  }
}

resource "aws_iam_role" "role" {
  description            = var.description
  name                   = var.role_name
  assume_role_policy     = data.aws_iam_policy_document.aws_trust_policy.json
  managed_policy_arns    = var.iam_policies_to_attach
  force_detach_policies  = true
}

