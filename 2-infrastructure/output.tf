output "eks" {
  value     = module.eks
  sensitive = true
}

output "vpc" {
  value     = module.vpc
  sensitive = true
}