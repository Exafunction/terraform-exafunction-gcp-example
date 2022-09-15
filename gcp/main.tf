locals {
  unique_suffix = var.unique_suffix == "" ? "" : "-${var.unique_suffix}"
  cluster_name  = "exafunction-cluster${local.unique_suffix}"
}

module "exafunction_network" {
  source  = "Exafunction/exafunction-cloud/gcp//modules/network"
  version = "0.1.0"

  vpc_name    = "exafunction-vpc${local.unique_suffix}"
  subnet_name = "exafunction-subnet${local.unique_suffix}"
  region      = var.region

  nodes_ip_range    = var.vpc_ip_range_config.nodes_ip_range
  pods_ip_range     = var.vpc_ip_range_config.pods_ip_range
  services_ip_range = var.vpc_ip_range_config.services_ip_range

  allow_ssh = var.allow_ssh
}

module "exafunction_cluster" {
  source  = "Exafunction/exafunction-cloud/gcp//modules/cluster"
  version = "0.1.0"

  cluster_name = "exafunction-cluster${local.unique_suffix}"
  region       = var.region

  vpc_name                      = module.exafunction_network.vpc_name
  subnet_name                   = module.exafunction_network.subnet_name
  pods_secondary_range_name     = module.exafunction_network.pods_secondary_range_name
  services_secondary_range_name = module.exafunction_network.services_secondary_range_name

  runner_pools = var.runner_pools
}

module "exafunction_module_repo_backend" {
  source  = "Exafunction/exafunction-cloud/gcp//modules/module_repo_backend"
  version = "0.1.0"

  exadeploy_id = "exa-mrbe${local.unique_suffix}"

  vpc_id = module.exafunction_network.vpc_id
  region = var.region
}

data "google_compute_network" "peer" {
  count = var.vpc_peering_config.enabled ? 1 : 0

  name = var.vpc_peering_config.peer_vpc_name
}

data "google_compute_subnetwork" "peer_subnets" {
  for_each = var.vpc_peering_config.enabled ? toset(var.vpc_peering_config.peer_subnet_names) : toset([])
  name     = each.key
}

module "exafunction_peering" {
  count = var.vpc_peering_config.enabled ? 1 : 0

  source  = "Exafunction/exafunction-cloud/gcp//modules/peering"
  version = "0.1.0"

  unique_suffix      = local.unique_suffix
  vpc_self_link      = module.exafunction_network.vpc_self_link
  peer_vpc_self_link = one(data.google_compute_network.peer).self_link
  peer_subnet_ip_ranges = flatten([
    for _, subnet in data.google_compute_subnetwork.peer_subnets : concat([subnet.ip_cidr_range], [for secondary_ip_range in subnet.secondary_ip_range : secondary_ip_range.ip_cidr_range])
  ])
}
