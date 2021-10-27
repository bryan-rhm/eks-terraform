locals {
  default_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Name        = var.cluster_name
  }
}
