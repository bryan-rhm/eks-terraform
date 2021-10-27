variable "region" {
  description = "aws region"
  default     = "us-east-1"
  type        = string
}

# eks cluster
variable "cluster_name" {
  description = "EKS Cluster Name"
  default     = "k8s"
  type        = string
}


variable "administration_cidrs" {
  description = "Whitelist of cidrs to manage eks cluster"
  default     = ["0.0.0.0/0"] # since I dont have a vpn or static ip I use 0.0.0.0/0
  type        = list(string)
}



