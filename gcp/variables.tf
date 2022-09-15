variable "project" {
  description = "GCP project ID."
  type        = string

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

variable "unique_suffix" {
  description = "Unique suffix to add to the GCP resources. Useful if trying to spin up multiple Exafunction clusters."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9\\-]*$", var.unique_suffix))
    error_message = "Invalid unique suffix format."
  }
}

variable "vpc_ip_range_config" {
  description = "IP ranges for the VPC's subnet. If using VPC peering, these should be disjoint from the IP ranges of the peered VPC's subnets. `nodes_ip_range` is the primary IP range for the subnet and used for all node IP addresses. `pods_ip_range` is a secondary IP range for the subnet and used for all pod IP addresses. `services_ip_range` is a secondary IP range for the subnet and used for all service IP addresses. It is recommended to use /20 ranges for `nodes_ip_range` and `services_ip_range` and a /16 range for `pods_ip_range`."
  type = object({
    nodes_ip_range    = string
    pods_ip_range     = string
    services_ip_range = string
  })
  default = {
    nodes_ip_range    = "10.0.0.0/20",
    pods_ip_range     = "10.1.0.0/16",
    services_ip_range = "10.2.0.0/20",
  }
}

variable "allow_ssh" {
  description = "Allow ssh into instances in the VPC."
  type        = bool
  default     = false
}

variable "runner_pools" {
  description = "Configuration parameters for Exafunction runner node pools."
  type = list(object({
    # Node group suffix.
    suffix = string
    # Machine type to use.
    machine_type = string
    # One of (ON_DEMAND, PREEMPTIBLE, SPOT).
    capacity_type = string
    # Disk size (GB).
    disk_size = number
    # Minimum number of nodes per zone.
    min_size = number
    # Maximum number of nodes per zone.
    max_size = number
    # Type of accelerator to attach. If empty, no accelerator is attached.
    accelerator_type = string
    # The number of accelerators to attach.
    accelerator_count = number
    # List of zones for the Exafunction runner node pool. Zones must be within the same region as
    # the cluster. For node pools with attached accelerators, must specify a list of zones where
    # the accelerators are available. If empty, use the default set of zones for the region.
    node_zones = list(string)
    # Additional taints.
    additional_taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    # Additional labels.
    additional_labels = map(string)
  }))
  default = [{
    suffix            = "gpu"
    machine_type      = "n1-standard-4"
    capacity_type     = "ON_DEMAND"
    disk_size         = 100
    min_size          = 0
    max_size          = 3
    accelerator_type  = "nvidia-tesla-t4"
    accelerator_count = 1
    node_zones        = ["us-west1-a", "us-west1-b"]
    additional_taints = []
    additional_labels = {}
  }]
  validation {
    condition = alltrue([
      for runner_pool in var.runner_pools : contains(["ON_DEMAND", "PREEMPTIBLE", "SPOT"], runner_pool.capacity_type)
    ])
    error_message = "Capacity type must be one of [ON_DEMAND, PREEMPTIBLE, SPOT]."
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
