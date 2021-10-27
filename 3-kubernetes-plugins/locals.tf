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
      role_arn = local.infrastructure.pipeline_role_arn
      username = "pipelineUser:{{SessionName}}"
      group    = "PowerUserGroup"
    }
  ]
}