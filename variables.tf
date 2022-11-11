variable "purpose" {
  type        = string
  description = "Purpose for the bucket and KMS key, used in the description fields."
}

variable "service_principals" {
  type        = list(string)
  default     = []
  description = "List of service principals that can access the bucket."
}

variable "iam_principals" {
  type        = list(string)
  default     = []
  description = "List of IAM principals that can access the bucket."
}

variable "object_actions" {
  type        = list(string)
  default     = ["s3:PutObject"]
  description = "List of object actions that the principals are allowed to execute."
}

variable "bucket_actions" {
  type        = list(string)
  default     = []
  description = "List of bucket actions that the principals are allowed to execute."
}

variable "kms_actions" {
  type        = list(string)
  default     = ["kms:GenerateDataKey*"]
  description = "List of KMS key actions that the principals are allowed to execute."
}

variable "acl" {
  type        = string
  default     = "private"
  description = "Bucket ACL"
}

variable "versioning" {
  type        = bool
  default     = true
  description = "Object versioning"
}

variable "logging" {
  type        = map(string)
  description = "Map containing access bucket logging configuration."
  default     = {}
}

variable "bucket_prefix" {
  type        = string
  description = "Instead of a bucket name we use a bucket-prefix, also used for KMS key alias prefix."
}

variable "attach_elb_log_delivery_policy" {
  type        = bool
  default     = false
  description = "Attach ELB log delivery policy"
}

variable "attach_lb_log_delivery_policy" {
  type        = bool
  default     = false
  description = "Attach LB log delivery policy"
}

variable "encrypt_with_aws_managed_keys" {
  type        = bool
  default     = false
  description = "Encrypt the data with a KMS key"
}

variable "lifecycle_rule" {
  type = any
  default = [{
    id      = "lifecycle-rule-1"
    enabled = true

    transition = [
      {
        days          = 30
        storage_class = "ONEZONE_IA"
        }, {
        days          = 60
        storage_class = "GLACIER"
      }
    ]

    noncurrent_version_expiration = {
      days = 90
    }
  }]
  description = "List of maps containing configuration of object lifecycle management."
}
