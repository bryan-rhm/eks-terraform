variable "tags" {
  type    = map(string)
  default = {}
}

variable "key_description" {
  description = "Description of the purpose of the KMS key"
  default     = "KMS key for encrypting sensitive data"
}


variable "key_alias" {
  description = "Alias of the key to be created"
  type        = string
}

variable "principal" {
  description = "AWS Principal allowed to use the key"
  type        = string
  default     = ""
}

variable "enable_key_rotation" {
  description = "Enable the rotation of the KMS key created"
  default     = false
}

variable "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource"
  default     = 10
}

variable "custom_policy" {
  description = "Determines wheter the module recibes a custom policy or not"
  default     = ""
}
