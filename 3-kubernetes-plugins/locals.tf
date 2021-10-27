locals {
  default_tags  = {
    Environment = terraform.workspace
    ManagedBy   = "terraform"
  }
  infrastructure   = data.terraform_remote_state.infrastructure.outputs
  cluster_name     = local.infrastructure.eks.cluster-name
  cluster_endpoint = local.infrastructure.eks.endpoint
  cluster_cert     = local.infrastructure.eks.ca
  nodegroup_role   = local.infrastructure.eks.nodegroup_role

  map_roles = [
    {
      role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/PipelineRole"
      username = "pipelineUser:{{SessionName}}"
      group    = "PowerUserGroup"
    }
  ]
}