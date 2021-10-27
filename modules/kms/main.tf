resource "aws_kms_key" "key" {
  description             = var.key_description
  deletion_window_in_days = var.deletion_window_in_days
  policy                  = data.aws_iam_policy_document.combined.json
  enable_key_rotation     = var.enable_key_rotation

  tags = var.tags
}

# Reads custom policy sent by module execution, regardless if it's empty or not
data "aws_iam_policy_document" "custom_policy" {
  override_json = var.custom_policy
}

# Joins KMS key default policy with the custom policy sent by the module execution
# This allow us to decouple changes from the module while give us the possibility to add custom services policies
data "aws_iam_policy_document" "combined" {
  source_policy_documents = [
    data.aws_iam_policy_document.kms_key_policy.json,
    data.aws_iam_policy_document.custom_policy.json
  ]
}

# Every KMS key must have a policy enabling IAM resources or Services to access them. Mandatory
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid = "Enable IAM User Permissions"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.aws_principal}:root"]
    }

    actions = [
      "kms:*",
    ]

    resources = ["*"]
  }
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.key_alias}"
  target_key_id = aws_kms_key.key.key_id
}
