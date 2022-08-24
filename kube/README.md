# kube

This Terraform module is used to set up the ExaDeploy system inside an existing GKE cluster (created using the `gcp` module).

After deployment, ExaDeloy clients will be able to communicate with the ExaDeploy system and offload remote GPU computation to ExaDeploy.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.33.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_exafunction_kube"></a> [exafunction\_kube](#module\_exafunction\_kube) | https://storage.googleapis.com/exafunction-dist/terraform-exafunction-kube-gcp-6387b92.tar.gz//terraform-exafunction-kube-gcp-6387b92 | n/a |

## Resources

| Name | Type |
|------|------|
| [google_client_config.provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_container_cluster.cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |
| [terraform_remote_state.cluster](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key used to identify the user to the Exafunction API. | `string` | n/a | yes |
| <a name="input_exafunction_chart_version"></a> [exafunction\_chart\_version](#input\_exafunction\_chart\_version) | Version of the Exafunction Helm chart to install. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | GCP project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for existing GKE cluster. | `string` | n/a | yes |
| <a name="input_remote_state_config"></a> [remote\_state\_config](#input\_remote\_state\_config) | Configuration parameters for the cluster Terraform's remote state (GCS). | <pre>object({<br>    bucket = string<br>    prefix = string<br>  })</pre> | n/a | yes |
| <a name="input_values_file_path"></a> [values\_file\_path](#input\_values\_file\_path) | Path to values YAML file to pass to exafunction-cluster Helm chart. Format should match values.yaml.example. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
