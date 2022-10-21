resource "aws_s3_bucket_policy" "bucket" {
  bucket = module.bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.combined.json
}

module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.2.0"

  bucket_prefix = substr(var.bucket_prefix, 0, 36)
  acl           = var.acl

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_policy     = true
  block_public_acls       = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.encrypt_with_aws_managed_keys ? null : aws_kms_key.kms[0].arn
        sse_algorithm     = var.encrypt_with_aws_managed_keys ? "AES256" : "aws:kms"
      }
    }
  }
  versioning = {
    enabled = var.versioning
  }

  lifecycle_rule = var.lifecycle_rule
  logging = var.logging
}
