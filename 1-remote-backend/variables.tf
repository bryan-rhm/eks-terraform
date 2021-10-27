variable "project_name" {
	description = "This variable is used as prefix for s3 and dynamo table"
	default     = "bryan-test"
}

variable "region" {
  description = "Region where the resources would be deployed"
  default     = "us-east-1"
}

# GITHUB ROLE

variable "github_org" {
  description = "Github Organization name"
  default     = "bryan-rhm"
  type        = string
}

variable "github_thumbprint" {
  description = "Github ThumbprintList"
  default     = "66BDD7C74D920085F0A986FB5AE3AB4FACCAF635"
  type        = string
}

variable "github_token_url" {
  description = "Github OIDC token url"
  default     = "https://token.actions.githubusercontent.com"
  type        = string
}
