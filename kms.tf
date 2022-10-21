data "aws_iam_policy_document" "kms" {
  statement {
    sid       = "Full permissions for root"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }
  dynamic "statement" {
    for_each = { for principal in var.service_principals : principal => principal }
    content {
      sid       = "Allow KMS Use by ${var.purpose} by ${statement.key}"
      effect    = "Allow"
      actions   = var.kms_actions
      resources = ["*"]
      principals {
        type        = "Service"
        identifiers = [statement.key]
      }
    }
  }
  dynamic "statement" {
    for_each = { for principal in var.iam_principals : principal => principal }
    content {
      sid       = "Allow KMS Use by ${var.purpose} by ${statement.key}"
      effect    = "Allow"
      actions   = var.kms_actions
      resources = ["*"]
      principals {
        type        = "AWS"
        identifiers = [statement.key]
      }
    }
  }
}

resource "aws_kms_key" "kms" {
  count                   = var.encrypt_with_aws_managed_keys ? 0 : 1
  description             = "KMS Key for ${var.purpose}"
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.kms.json
  enable_key_rotation     = true
}
