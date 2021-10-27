# --------------------------------------------------------------------
# aws-auth ConfigMap
# --------------------------------------------------------------------

# ## generate base template for workers
data "template_file" "worker_role_arns" {
  template = file("${path.module}/templates/worker-role.tpl")

  vars = {
    workers_role_arn = local.nodegroup_role
  }
}

## generate templates mapping IAM roles with cluster entities (users/groups)
data "template_file" "map_roles" {
  count    = length(local.map_roles)
  template = file("${path.module}/templates/aws-auth_map-roles.yaml.tpl")

  vars = {
    role_arn = local.map_roles[count.index]["role_arn"]
    username = local.map_roles[count.index]["username"]
    group    = local.map_roles[count.index]["group"]
  }
}

### Import this resource, and then apply so it gets update
resource "kubernetes_config_map" "aws_auth_cm" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = join(
      "",
      data.template_file.map_roles.*.rendered,
      data.template_file.worker_role_arns.*.rendered,
    )
  }
}
