data "aws_caller_identity" "current" {}

locals {
  aws_principal = var.principal == "" ? data.aws_caller_identity.current.account_id : var.principal
}
