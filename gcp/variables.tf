variable "project" {
  description = "GCP project ID."
  type = string

  validation {
    condition     = can(regex("^[a-z0-9\\-]{6,30}$", var.project))
    error_message = "Invalid GCP project ID format."
  }
}

variable "region" {
  description = "Region for VPC and GKE. If using VPC peering, this should be the same as the region of the peered VPC."
  type        = string

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "Invalid GCP region format."
  }
}

variable "cluster_suffix" {
  description = "Unique suffix to add to the cluster (and VPC). Useful if trying to spin up multiple Exafunction clusters."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9\\-]*$", var.cluster_suffix))
    error_message = "Invalid cluster suffix format."
  }
}

variable "vpc_ip_range_config" {
  description = "IP ranges for the VPC's subnet. If using VPC peering, these should be disjoint from the IP ranges of the peered VPC's subnets. `instances_primary_range` is the primary IP range for the subnet and used for all node IP addresses. `pods_secondary_range` is a secondary IP range for the subnet and used for all pod IP addresses. `services_secondary_range` is a secondary IP range for the subnet and used for all service IP addresses. It is recommended to use /20 ranges for `instances_primary_range` and `services_secondary_range` and a /16 range for `pods_secondary_range`."
  type = object({
    instances_primary_range  = string
    pods_secondary_range     = string
    services_secondary_range = string
  })
  default = {
    instances_primary_range  = "10.0.0.0/20",
    pods_secondary_range     = "10.1.0.0/16",
    services_secondary_range = "10.2.0.0/20",
  }
}

variable "vpc_peering_config" {
  description = "VPC peering connection configuration. `peer_vpc_name` is the name of the VPC to peer with. `peer_subnet_names` are the list of subnet names that are expected to send requests to the ExaDeploy cluster."
  type = object({
    enabled           = bool
    peer_vpc_name     = string
    peer_subnet_names = list(string)
  })

  validation {
    condition     = !var.vpc_peering_config.enabled || (length(var.vpc_peering_config.peer_vpc_name) > 0 && length(var.vpc_peering_config.peer_subnet_names) > 0)
    error_message = "`peer_vpc_name` and `peer_subnet_names` are required when VPC peering is enabled."
  }
}

variable "gpu_node_config" {
  description = "GPU node configuration. `machine_type` is the GCE machine type to use for the GPU nodes. `min_gpu_nodes` and `max_gpu_nodes` define the minimum and maximum number of nodes in the GPU node pool. `accelerator_type` is the type of the GPU accelerator to use. `accelerator_count` is the number of accelerators to attach. `node_zones` is the list of zones for the GPU node pool. Zones must be within the same region as the cluster and must have accelerators of `accelerator_type` available."
  type = object({
    machine_type     = string
    min_gpu_nodes    = number
    max_gpu_nodes    = number
    accelerator_type = string
    accelerator_count = number
    node_zones       = list(string)
  })
  default = {
    machine_type     = "n1-standard-4"
    min_gpu_nodes    = 1
    max_gpu_nodes    = 10
    accelerator_type = "nvidia-tesla-t4"
    accelerator_count = 1
    node_zones       = ["us-west1-a", "us-west1-b"]
  }
}
