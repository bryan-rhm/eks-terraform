variable "region" {
  description = "aws region"
  default     = "us-east-1"
  type        = string
}

### helm eks plugins variables ###

variable "cluster_autoscaler_version" {
  # more info at https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
  description = "helm chart version of cluster autoscaler"
  type        = string
  default     = "9.9.2"
}

variable "metric_server_version" {
  # more info at https://artifacthub.io/packages/helm/bitnami/metrics-server
  # official manifest https://github.com/kubernetes-sigs/external-dns
  description = "helm chart version of metrics server"
  type        = string
  default     = "5.8.7"
}

variable "external_dns_version" {
  # more info https://artifacthub.io/packages/helm/bitnami/external-dns
  # official manifest https://github.com/kubernetes-sigs/metrics-server/releases
  description = "helm chart version of external dns"
  type        = string
  default     = "5.0.0"
}

variable "plugins_namespace" {
  description = "kubernetes namespace for plugins to be allocated, default namespace should be avoided, using kube-system"
  type        = string
  default     = "kube-system"
}

variable "autoscaler_sa_name" {
  description = "kubernetes service account name for cluster autoscaler, this value has to match the one used in the role definition"
  type        = string
  default     = "aws-cluster-autoscaler"
}

variable "external_dns_sa_name" {
  description = "kubernetes service account name for external-dns, this value has to match the one used in the role definition"
  type        = string
  default     = "external-dns"
}

variable "aws_lb_controller_sa_name" {
  description = "kubernetes service account name for aws-lb-controller plugin, this value has to match the one used in the role definition"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "aws_lb_controller_version" {
  # home of the chart https://aws.github.io/eks-charts
  description = "aws-lb-controller helm chart version"
  type        = string
  default     = "1.2.0"
}

variable "cluster_name" {
  description = "cluster name, this is used for tags, and helm chart values"
  type        = string
  default     = "k8s"
}

variable "map_roles" {
  description = "A list of maps with the roles allowed to access EKS"
  type = list(object({
    role_arn = string
    username = string
    group    = string
  }))
  default = []
  # example:
  #
  #  map_roles = [
  #    {
  #      role_arn = "arn:aws:iam::<aws-account>:role/ReadOnly"
  #      username = "john"
  #      group    = "system:masters" # cluster-admin
  #    },
  #    {
  #      role_arn = "arn:aws:iam::<aws-account>:role/Admin"
  #      username = "peter"
  #      group    = "ReadOnlyGroup"  # custom role granting read-only permissions
  #    }
  #  ]
  #
}
