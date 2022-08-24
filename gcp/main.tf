locals {
  cluster_suffix = var.cluster_suffix == "" ? "" : "-${var.cluster_suffix}"
  cluster_name   = "exafunction-cluster${local.cluster_suffix}"
}

resource "google_compute_network" "vpc" {
  name                    = "exafunction-vpc${local.cluster_suffix}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "exafunction-subnet${local.cluster_suffix}"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_ip_range_config.instances_primary_range

  secondary_ip_range {
    range_name    = "pod-ip-range"
    ip_cidr_range = var.vpc_ip_range_config.pods_secondary_range
  }

  secondary_ip_range {
    range_name    = "service-ip-range"
    ip_cidr_range = var.vpc_ip_range_config.services_secondary_range
  }
}

module "exafunction" {
  source                        = "https://storage.googleapis.com/exafunction-dist/terraform-exafunction-gcp-341261e.tar.gz//terraform-exafunction-gcp-341261e"
  cluster_name                  = local.cluster_name
  region                        = var.region
  vpc_name                      = google_compute_network.vpc.name
  vpc_id                        = google_compute_network.vpc.id
  subnet_name                   = google_compute_subnetwork.subnet.name
  pods_secondary_range_name     = "pod-ip-range"
  services_secondary_range_name = "service-ip-range"
  runner_pools = [{
    suffix           = "gpu"
    machine_type     = var.gpu_node_config.machine_type
    min_capacity     = var.gpu_node_config.min_gpu_nodes
    max_capacity     = var.gpu_node_config.max_gpu_nodes
    node_zones       = var.gpu_node_config.node_zones
    accelerator_type = var.gpu_node_config.accelerator_type
  }]
}

data "google_compute_network" "peer" {
  name = var.vpc_peering_config.peer_vpc_name
}

data "google_compute_subnetwork" "peer_subnets" {
  for_each = toset(var.vpc_peering_config.peer_subnet_names)
  name     = each.key
}

module "vpc_peer" {
  count = var.vpc_peering_config.enabled ? 1 : 0

  source             = "./modules/vpc_peer"
  unique_suffix      = local.cluster_suffix
  vpc_self_link      = google_compute_network.vpc.self_link
  peer_vpc_self_link = data.google_compute_network.peer.self_link
  peer_subnet_ip_ranges = flatten([
    for _, subnet in data.google_compute_subnetwork.peer_subnets : concat([subnet.ip_cidr_range], [for secondary_ip_range in subnet.secondary_ip_range : secondary_ip_range.ip_cidr_range])
  ])
}
