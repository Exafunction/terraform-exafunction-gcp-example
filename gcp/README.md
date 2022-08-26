# gcp

This Terraform module is used to set up a new GKE cluster that can be integrated with existing infrastructure outside of GKE (or in an existing, separate GKE cluster). It is responsible for creating a new VPC, new GKE cluster, and optional VPC peering mechanism (along with associated firewall rules) between an existing VPC and the newly created VPC.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.33.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_exafunction"></a> [exafunction](#module\_exafunction) | https://storage.googleapis.com/exafunction-dist/terraform-exafunction-gcp-629741c.tar.gz//terraform-exafunction-gcp-629741c | n/a |
| <a name="module_vpc_peer"></a> [vpc\_peer](#module\_vpc\_peer) | ./modules/vpc_peer | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.rules](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network.vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_network.peer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network) | data source |
| [google_compute_subnetwork.peer_subnets](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ssh"></a> [allow\_ssh](#input\_allow\_ssh) | Allow ssh into instances in the VPC. | `bool` | `false` | no |
| <a name="input_cluster_suffix"></a> [cluster\_suffix](#input\_cluster\_suffix) | Unique suffix to add to the cluster (and VPC). Useful if trying to spin up multiple Exafunction clusters. | `string` | `""` | no |
| <a name="input_gpu_node_config"></a> [gpu\_node\_config](#input\_gpu\_node\_config) | GPU node configuration. `machine_type` is the GCE machine type to use for the GPU nodes. `min_gpu_nodes` and `max_gpu_nodes` define the minimum and maximum number of nodes in the GPU node pool. `accelerator_type` is the type of the GPU accelerator to use. `accelerator_count` is the number of accelerators to attach. `node_zones` is the list of zones for the GPU node pool. Zones must be within the same region as the cluster and must have accelerators of `accelerator_type` available. | <pre>object({<br>    machine_type     = string<br>    min_gpu_nodes    = number<br>    max_gpu_nodes    = number<br>    accelerator_type = string<br>    accelerator_count = number<br>    node_zones       = list(string)<br>  })</pre> | <pre>{<br>  "accelerator_count": 1,<br>  "accelerator_type": "nvidia-tesla-t4",<br>  "machine_type": "n1-standard-4",<br>  "max_gpu_nodes": 10,<br>  "min_gpu_nodes": 1,<br>  "node_zones": [<br>    "us-west1-a",<br>    "us-west1-b"<br>  ]<br>}</pre> | no |
| <a name="input_project"></a> [project](#input\_project) | GCP project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for VPC and GKE. If using VPC peering, this should be the same as the region of the peered VPC. | `string` | n/a | yes |
| <a name="input_vpc_ip_range_config"></a> [vpc\_ip\_range\_config](#input\_vpc\_ip\_range\_config) | IP ranges for the VPC's subnet. If using VPC peering, these should be disjoint from the IP ranges of the peered VPC's subnets. `instances_primary_range` is the primary IP range for the subnet and used for all node IP addresses. `pods_secondary_range` is a secondary IP range for the subnet and used for all pod IP addresses. `services_secondary_range` is a secondary IP range for the subnet and used for all service IP addresses. It is recommended to use /20 ranges for `instances_primary_range` and `services_secondary_range` and a /16 range for `pods_secondary_range`. | <pre>object({<br>    instances_primary_range  = string<br>    pods_secondary_range     = string<br>    services_secondary_range = string<br>  })</pre> | <pre>{<br>  "instances_primary_range": "10.0.0.0/20",<br>  "pods_secondary_range": "10.1.0.0/16",<br>  "services_secondary_range": "10.2.0.0/20"<br>}</pre> | no |
| <a name="input_vpc_peering_config"></a> [vpc\_peering\_config](#input\_vpc\_peering\_config) | VPC peering connection configuration. `peer_vpc_name` is the name of the VPC to peer with. `peer_subnet_names` are the list of subnet names that are expected to send requests to the ExaDeploy cluster. | <pre>object({<br>    enabled           = bool<br>    peer_vpc_name     = string<br>    peer_subnet_names = list(string)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the GKE cluster. |
| <a name="output_project"></a> [project](#output\_project) | GCP project ID. |
| <a name="output_region"></a> [region](#output\_region) | Region of the GKE cluster. |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | Name of the VPC. |
| <a name="output_vpc_self_link"></a> [vpc\_self\_link](#output\_vpc\_self\_link) | Self link for the VPC. |
<!-- END_TF_DOCS -->
