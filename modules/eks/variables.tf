variable "cluster_name" {
  description = "EKS Cluster Name"
  default     = "application"
  type        = string
}

variable "administration_cidrs" {
  description = "CIDR from Network account to manage eks cluster"
  default     = ["10.8.0.0/16", "10.118.0.0/16"]
  type        = list(string)
}


variable "cluster_log_types" {
  description = "List of the cluster logs we want to enable"
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler", ]
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Configure eks api endpoint to be private"
  default     = false
  type        = bool
}

variable "endpoint_public_access" {
  description = "Configure eks api endpoint to be private"
  default     = true
  type        = bool
}

variable "subnet_ids" {
  description = "Subnets ids to place workers"
  default     = [""]
  type        = list(string)
}

variable "cluster_version" {
  description = "EKS control plane version"
  default     = "1.19"
  type        = string
}

variable "environment" {
  description = "Environment prefix"
  default     = "default"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type for worker nodes"
  default     = "t3.small"
  type        = string
}

variable "key_name" {
  description = "EC2 keypair for worker nodes"
  default     = ""
  type        = string
}

variable "vpc_id" {
  description = "VPC id where nodes will be placed"
  default     = ""
  type        = string
}

variable "cidr_block" {
  description = "VPC cidr block"
  default     = ""
  type        = string
}

variable "tags" {
  default = {}
  type    = map(any)
}

variable "worker_node_policies" {
  type = list(string)

  default = [
    "AmazonEKSWorkerNodePolicy",
    "AmazonEKS_CNI_Policy",
    "AmazonEC2ContainerRegistryReadOnly",
    "CloudWatchAgentServerPolicy",
    "AmazonSSMManagedInstanceCore",
    "CloudWatchFullAccess"
  ]
}

variable "autoscaler_version" {
  default = "v1.20.0"
}

variable "worker" {
  type        = map(string)
  description = "Map of EKS workers settings"

  default = {
    instance_type         = "t3.large"
    desired_size          = "2"
    min_size              = "1"
    max_size              = "4"
    key_name              = ""
    volume_size           = "30"
    encrypted             = true
    volume_type           = "gp2"
    delete_on_termination = true
  }
}
