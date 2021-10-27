module "vpc" {
  source = "../modules/vpc"

  environment                         = local.environment
  enable_nat_gw                       = true
  single_nat_gw                       = false
  enable_dns_support                  = true
  region                              = var.region
  vpc_cidr                            = local.vpc_cidr
  azs                                 = local.azs
  public_subnet_cidrs                 = local.public_subnet_cidrs
  private_subnet_cidrs                = local.private_subnet_cidrs
  db_subnet_cidrs                     = local.database_subnet_cidrs
  allow_inbound_traffic_public_subnet = local.allow_inbound_traffic

  # Tags needed for EKS to identify public and private subnets
  eks_network_tags = {
    "kubernetes.io/cluster/${local.environment}-${var.cluster_name}" = "shared"
  }

  eks_private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  eks_public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

}

module "eks" {
  source = "../modules/eks"

  cluster_name         = var.cluster_name
  subnet_ids           = module.vpc.private_subnet_ids
  environment          = local.environment
  vpc_id               = module.vpc.vpc_id
  cidr_block           = local.vpc_cidr
  worker               = local.worker_nodes[local.environment]
  administration_cidrs = var.administration_cidrs

  depends_on = [module.vpc]
}