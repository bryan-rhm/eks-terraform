provider "aws" {
  region = var.region
  default_tags {
    tags = local.default_tags
  }
}
  

### Authentication toke required for kubernetes and helm providers

data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.infrastructure.outputs.eks.cluster-name
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.infrastructure.outputs.eks.endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.infrastructure.outputs.eks.ca)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.infrastructure.outputs.eks.endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.infrastructure.outputs.eks.ca)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
