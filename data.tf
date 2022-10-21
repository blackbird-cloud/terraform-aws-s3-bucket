locals {
  account_id = data.aws_caller_identity.current.account_id
  iam_principals_bucket_actions = compact(flatten([
    for principal in var.iam_principals : [
      for action in var.bucket_actions : principal
    ]
  ]))
  service_principals_bucket_actions = compact(flatten([
    for principal in var.service_principals : [
      for action in var.bucket_actions : principal
    ]
  ]))
  iam_principals_object_actions = compact(flatten([
    for principal in var.iam_principals : [
      for action in var.object_actions : principal
    ]
  ]))
  service_principals_object_actions = compact(flatten([
    for principal in var.service_principals : [
      for action in var.object_actions : principal
    ]
  ]))
}

data "aws_caller_identity" "current" {}

data "aws_elb_service_account" "this" {
  count = var.attach_elb_log_delivery_policy ? 1 : 0
}

data "aws_iam_policy_document" "elb_log_delivery" {
  count = var.attach_elb_log_delivery_policy ? 1 : 0

  statement {
    sid       = ""
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${module.bucket.s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = data.aws_elb_service_account.this.*.arn
    }
  }
}

data "aws_iam_policy_document" "lb_log_delivery" {
  count = var.attach_lb_log_delivery_policy ? 1 : 0

  statement {
    sid       = "AWSLogDeliveryWrite"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${module.bucket.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid       = "AWSLogDeliveryAclCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [module.bucket.s3_bucket_arn]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3" {
  dynamic "statement" {
    for_each = { for principal in local.service_principals_object_actions : principal => principal }
    content {
      effect    = "Allow"
      actions   = var.object_actions
      resources = ["${module.bucket.s3_bucket_arn}/*"]
      principals {
        type        = "Service"
        identifiers = [statement.key]
      }
    }
  }
  dynamic "statement" {
    for_each = { for principal in local.iam_principals_object_actions : principal => principal }
    content {
      effect    = "Allow"
      actions   = var.object_actions
      resources = ["${module.bucket.s3_bucket_arn}/*"]
      principals {
        type        = "AWS"
        identifiers = [statement.key]
      }
    }
  }
  dynamic "statement" {
    for_each = { for principal in local.service_principals_bucket_actions : principal => principal }
    content {
      effect    = "Allow"
      actions   = var.bucket_actions
      resources = [module.bucket.s3_bucket_arn]
      principals {
        type        = "Service"
        identifiers = [statement.key]
      }
    }
  }
  dynamic "statement" {
    for_each = { for principal in local.iam_principals_bucket_actions : principal => principal }
    content {
      effect    = "Allow"
      actions   = var.bucket_actions
      resources = [module.bucket.s3_bucket_arn]
      principals {
        type        = "AWS"
        identifiers = [statement.key]
      }
    }
  }
}

data "aws_iam_policy_document" "require_latest_tls" {
  statement {
    sid     = "denyOutdatedTLS"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      module.bucket.s3_bucket_arn,
      "${module.bucket.s3_bucket_arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values = [
        "1.2"
      ]
    }
  }
}

data "aws_iam_policy_document" "deny_insecure_transport" {
  statement {
    sid     = "denyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]

    resources = [
      module.bucket.s3_bucket_arn,
      "${module.bucket.s3_bucket_arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "combined" {
  source_policy_documents = compact([
    data.aws_iam_policy_document.require_latest_tls.json,
    data.aws_iam_policy_document.deny_insecure_transport.json,
    data.aws_iam_policy_document.s3.json,
    var.attach_elb_log_delivery_policy ? data.aws_iam_policy_document.elb_log_delivery[0].json : "",
    var.attach_lb_log_delivery_policy ? data.aws_iam_policy_document.lb_log_delivery[0].json : "",
  ])
}
