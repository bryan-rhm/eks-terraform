module "helm_eks_plugins" {
  source = "../modules/helm_eks_plugins"

  plugins_namespace          = var.plugins_namespace
  aws_lb_controller_sa_name  = var.aws_lb_controller_sa_name
  aws_lb_controller_version  = var.aws_lb_controller_version
  enable_aws_lb_controller   = true
  autoscaler_sa_name         = var.autoscaler_sa_name
  cluster_autoscaler_version = var.cluster_autoscaler_version
  external_dns_sa_name       = var.external_dns_sa_name
  external_dns_version       = var.external_dns_version
  metric_server_version      = var.metric_server_version
  region                     = var.region
  cluster_name               = local.cluster_name
  oidc_issuer                = local.infrastructure.eks.oidc_issuer
  environment                = terraform.workspace
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}

## Bind the ClusterRole 'edit' to a group named 'PowerUserGroup'
resource "kubernetes_cluster_role_binding" "power_user" {
  metadata {
    name = "power-user-global"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  subject {
    kind      = "Group"
    name      = "PowerUserGroup"
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [kubernetes_config_map.aws_auth_cm]
}

resource "kubernetes_cluster_role_binding" "role_grantor_power_user" {
  metadata {
    name = "power-user-role-grantor"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "role-grantor"
  }

  subject {
    kind      = "Group"
    name      = "PowerUserGroup"
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [kubernetes_config_map.aws_auth_cm]

}