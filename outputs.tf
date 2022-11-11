output "bucket" {
  value       = module.bucket
  description = "AWS S3 Bucket"
}

output "kms" {
  value       = var.encrypt_with_aws_managed_keys ? null : aws_kms_key.kms[0]
  description = "AWS KMS key"
}

output "kms_alias" {
  value       = var.encrypt_with_aws_managed_keys ? null : aws_kms_alias.alias[0]
  description = "AWS KMS key alias"
}
