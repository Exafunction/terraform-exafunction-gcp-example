# gcp

This Terraform module is used to set up a new GKE cluster that can be integrated with existing infrastructure outside of GKE (or in an existing, separate GKE cluster). It is responsible for creating a new VPC, new GKE cluster, and optional VPC peering mechanism (along with associated firewall rules) between an existing VPC and the newly created VPC.

<!-- BEGIN_TF_DOCS -->
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_exafunction_cluster"></a> [exafunction\_cluster](#module\_exafunction\_cluster) | Exafunction/exafunction-cloud/gcp//modules/cluster | 0.1.0 |
| <a name="module_exafunction_module_repo_backend"></a> [exafunction\_module\_repo\_backend](#module\_exafunction\_module\_repo\_backend) | Exafunction/exafunction-cloud/gcp//modules/module_repo_backend | 0.1.0 |
| <a name="module_exafunction_network"></a> [exafunction\_network](#module\_exafunction\_network) | Exafunction/exafunction-cloud/gcp//modules/network | 0.1.0 |
| <a name="module_exafunction_peering"></a> [exafunction\_peering](#module\_exafunction\_peering) | Exafunction/exafunction-cloud/gcp//modules/peering | 0.1.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_network.peer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network) | data source |
| [google_compute_subnetwork.peer_subnets](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ssh"></a> [allow\_ssh](#input\_allow\_ssh) | Allow ssh into instances in the VPC. | `bool` | `false` | no |
| <a name="input_project"></a> [project](#input\_project) | GCP project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for VPC and GKE. If using VPC peering, this should be the same as the region of the peered VPC. | `string` | n/a | yes |
| <a name="input_runner_pools"></a> [runner\_pools](#input\_runner\_pools) | Configuration parameters for Exafunction runner node pools. | <pre>list(object({<br>    # Node group suffix.<br>    suffix = string<br>    # Machine type to use.<br>    machine_type = string<br>    # One of (ON_DEMAND, PREEMPTIBLE, SPOT).<br>    capacity_type = string<br>    # Disk size (GB).<br>    disk_size = number<br>    # Minimum number of nodes per zone.<br>    min_size = number<br>    # Maximum number of nodes per zone.<br>    max_size = number<br>    # Type of accelerator to attach. If empty, no accelerator is attached.<br>    accelerator_type = string<br>    # The number of accelerators to attach.<br>    accelerator_count = number<br>    # List of zones for the Exafunction runner node pool. Zones must be within the same region as<br>    # the cluster. For node pools with attached accelerators, must specify a list of zones where<br>    # the accelerators are available. If empty, use the default set of zones for the region.<br>    node_zones = list(string)<br>    # Additional taints.<br>    additional_taints = list(object({<br>      key    = string<br>      value  = string<br>      effect = string<br>    }))<br>    # Additional labels.<br>    additional_labels = map(string)<br>  }))</pre> | <pre>[<br>  {<br>    "accelerator_count": 1,<br>    "accelerator_type": "nvidia-tesla-t4",<br>    "additional_labels": {},<br>    "additional_taints": [],<br>    "capacity_type": "ON_DEMAND",<br>    "disk_size": 100,<br>    "machine_type": "n1-standard-4",<br>    "max_size": 3,<br>    "min_size": 0,<br>    "node_zones": [<br>      "us-west1-a",<br>      "us-west1-b"<br>    ],<br>    "suffix": "gpu"<br>  }<br>]</pre> | no |
| <a name="input_unique_suffix"></a> [unique\_suffix](#input\_unique\_suffix) | Unique suffix to add to the GCP resources. Useful if trying to spin up multiple Exafunction clusters. | `string` | `""` | no |
| <a name="input_vpc_ip_range_config"></a> [vpc\_ip\_range\_config](#input\_vpc\_ip\_range\_config) | IP ranges for the VPC's subnet. If using VPC peering, these should be disjoint from the IP ranges of the peered VPC's subnets. `nodes_ip_range` is the primary IP range for the subnet and used for all node IP addresses. `pods_ip_range` is a secondary IP range for the subnet and used for all pod IP addresses. `services_ip_range` is a secondary IP range for the subnet and used for all service IP addresses. It is recommended to use /20 ranges for `nodes_ip_range` and `services_ip_range` and a /16 range for `pods_ip_range`. | <pre>object({<br>    nodes_ip_range    = string<br>    pods_ip_range     = string<br>    services_ip_range = string<br>  })</pre> | <pre>{<br>  "nodes_ip_range": "10.0.0.0/20",<br>  "pods_ip_range": "10.1.0.0/16",<br>  "services_ip_range": "10.2.0.0/20"<br>}</pre> | no |
| <a name="input_vpc_peering_config"></a> [vpc\_peering\_config](#input\_vpc\_peering\_config) | VPC peering connection configuration. `peer_vpc_name` is the name of the VPC to peer with. `peer_subnet_names` are the list of subnet names that are expected to send requests to the ExaDeploy cluster. | <pre>object({<br>    enabled           = bool<br>    peer_vpc_name     = string<br>    peer_subnet_names = list(string)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the GKE cluster. |
| <a name="output_exafunction_cluster"></a> [exafunction\_cluster](#output\_exafunction\_cluster) | Exafunction cluster module. |
| <a name="output_exafunction_module_repo_backend"></a> [exafunction\_module\_repo\_backend](#output\_exafunction\_module\_repo\_backend) | Exafunction module repository backend module. |
| <a name="output_exafunction_network"></a> [exafunction\_network](#output\_exafunction\_network) | Exafunction network module. |
| <a name="output_exafunction_peering"></a> [exafunction\_peering](#output\_exafunction\_peering) | Exafunction peering module. |
| <a name="output_project"></a> [project](#output\_project) | GCP project ID. |
| <a name="output_region"></a> [region](#output\_region) | Region of the GKE cluster. |
<!-- END_TF_DOCS -->
