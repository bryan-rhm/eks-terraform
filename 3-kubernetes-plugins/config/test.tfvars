region = "us-east-1"

### mysql configuration for db and user creation

dbs             = ["test1", "test2"]
master_username = "master_user"

### eks_plugins values

plugins_namespace          = "kube-system"
autoscaler_sa_name         = "aws-cluster-autoscaler"
external_dns_sa_name       = "external-dns"
aws_lb_controller_sa_name  = "aws-load-balancer-controller"
cluster_autoscaler_version = "9.9.2"
external_dns_version       = "5.0.0"
metric_server_version      = "5.8.7"
aws_lb_controller_version  = "1.2.0"
enable_ts                  = false

map_roles = [
  {
    role_arn = "arn:aws:iam::XXXXX:role/XXXXXXXXXX"
    group    = "system:masters" # cluster-admin
    username = "Team1:{{SessionName}}"
  },
  {
    role_arn = "arn:aws:iam::XXXXXX:role/XXXXXX"
    group    = "system:masters" # cluster-admin
    username = "PowerUsers:{{SessionName}}"
  }
]
