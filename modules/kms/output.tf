output "kms_key_arn" {
  value = aws_kms_key.key.arn
}

output "kms_key_id" {
  value = aws_kms_key.key.key_id
}

output "kms_alias_arn" {
  value = aws_kms_alias.alias.arn
}

output "kms_alias_name" {
  value = aws_kms_alias.alias.name
}
