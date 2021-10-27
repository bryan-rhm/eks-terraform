terraform {
  required_version = "1.0.7"
  required_providers {
    aws  = {
      source  = "hashicorp/aws"
      version = "3.60.0"
    }
    kubernetes  = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
    template  = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    helm  = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
    http  = {
      source  = "hashicorp/http"
      version = "2.1.0"
    } 
  }
}
