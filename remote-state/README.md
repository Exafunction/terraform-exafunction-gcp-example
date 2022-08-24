# remote-state

This Terraform module is responsible for creating the GCS bucket to store remote Terraform state for the other modules. This module itself uses a local backend to store its state.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.33.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | GCP project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for GCS bucket | `string` | n/a | yes |
| <a name="input_remote_state_bucket_suffix"></a> [remote\_state\_bucket\_suffix](#input\_remote\_state\_bucket\_suffix) | Optional suffix for the GCS bucket to use for storing terraform state. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Name of the S3 bucket to use for storing Terraform state. |
<!-- END_TF_DOCS -->
