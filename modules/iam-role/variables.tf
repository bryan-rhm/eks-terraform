variable "role_name" {
  description = "Name for the role"
  type        = string
}

variable "description" {
  description = "Description for the IAM role"
  default     = "Created by terraform"
  type        = string
}

variable "trusted_identifier" {
  description   = "Entity allowed to assume the role"
  type          = object({
    type        = string       # Ex: AWS
    identifiers = list(string) # Ex: Account id (1234424) | AWS service  ec2.amazonaws.com
  })
}

variable "iam_policies_to_attach" {
  description = "List of ARNs of IAM policies to attach"
  default     = []
  type        = list(string)
}

