# get current region and account id
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  environment   = terraform.workspace
  default_tags  = {
    Environment = local.environment
    ManagedBy   = "terraform"
  }

  oidc_provider = replace(module.eks.oidc_provider_arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/", "")
  account_id    = data.aws_caller_identity.current.account_id

  ###################### NETWORKING ##########################
  vpcs_cidrs = {
    dev      = "10.20.0.0/16"
    staging  = "10.30.0.0/16"
  }
  vpc_cidr              = local.vpcs_cidrs[terraform.workspace]
  azs                   = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnet_cidrs   = [for i in [10, 20, 30] : cidrsubnet(local.vpc_cidr, 7, i)]
  private_subnet_cidrs  = [for i in [11, 21, 31] : cidrsubnet(local.vpc_cidr, 7, i)]
  database_subnet_cidrs = [for i in [12, 22, 32] : cidrsubnet(local.vpc_cidr, 7, i)]

  allow_inbound_traffic = [
    {
      protocol  = "tcp"
      from_port = 443
      to_port   = 443
      source    = "0.0.0.0/0"
    },
    {
      protocol  = "tcp"
      from_port = 80
      to_port   = 80
      source    = "0.0.0.0/0"
    },
  ]



  ###################### EKS ###################################

  worker_nodes = {
    dev = {
      instance_type         = "t3.medium"
      min_size              = "1"
      max_size              = "4"
      volume_size           = "30"
    }

    staging = {
      instance_type         = "t3.large"
      min_size              = "1"
      max_size              = "4"
      volume_size           = "40"
    }
  }

}
