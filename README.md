## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.36.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bucket"></a> [bucket](#module\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket_policy.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_elb_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deny_insecure_transport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.elb_log_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lb_log_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.require_latest_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | Bucket ACL | `string` | `"private"` | no |
| <a name="input_attach_elb_log_delivery_policy"></a> [attach\_elb\_log\_delivery\_policy](#input\_attach\_elb\_log\_delivery\_policy) | Attach ELB log delivery policy | `bool` | `false` | no |
| <a name="input_attach_lb_log_delivery_policy"></a> [attach\_lb\_log\_delivery\_policy](#input\_attach\_lb\_log\_delivery\_policy) | Attach LB log delivery policy | `bool` | `false` | no |
| <a name="input_bucket_actions"></a> [bucket\_actions](#input\_bucket\_actions) | List of bucket actions that the principals are allowed to execute. | `list(string)` | `[]` | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Instead of a bucket name we use a bucket-prefix, also used for KMS key alias prefix. | `string` | n/a | yes |
| <a name="input_encrypt_with_aws_managed_keys"></a> [encrypt\_with\_aws\_managed\_keys](#input\_encrypt\_with\_aws\_managed\_keys) | Encrypt the data with a KMS key | `bool` | `false` | no |
| <a name="input_iam_principals"></a> [iam\_principals](#input\_iam\_principals) | List of IAM principals that can access the bucket. | `list(string)` | `[]` | no |
| <a name="input_kms_actions"></a> [kms\_actions](#input\_kms\_actions) | List of KMS key actions that the principals are allowed to execute. | `list(string)` | <pre>[<br>  "kms:GenerateDataKey*"<br>]</pre> | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | List of maps containing configuration of object lifecycle management. | `any` | <pre>[<br>  {<br>    "enabled": true,<br>    "id": "lifecycle-rule-1",<br>    "noncurrent_version_expiration": {<br>      "days": 90<br>    },<br>    "transition": [<br>      {<br>        "days": 30,<br>        "storage_class": "ONEZONE_IA"<br>      },<br>      {<br>        "days": 60,<br>        "storage_class": "GLACIER"<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Map containing access bucket logging configuration. | `map(string)` | `{}` | no |
| <a name="input_object_actions"></a> [object\_actions](#input\_object\_actions) | List of object actions that the principals are allowed to execute. | `list(string)` | <pre>[<br>  "s3:PutObject"<br>]</pre> | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Purpose for the bucket and KMS key, used in the description fields. | `string` | n/a | yes |
| <a name="input_service_principals"></a> [service\_principals](#input\_service\_principals) | List of service principals that can access the bucket. | `list(string)` | `[]` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Object versioning | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | AWS S3 Bucket |
| <a name="output_kms"></a> [kms](#output\_kms) | AWS KMS key |
| <a name="output_kms_alias"></a> [kms\_alias](#output\_kms\_alias) | AWS KMS key alias |
