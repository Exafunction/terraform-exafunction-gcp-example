# GCP project ID.
project = "<GCP_PROJECT>"

# Region for GCP resources.
region = "us-west1"

# Region and IP ranges for the Exafunction VPC.
vpc_ip_range_config = {
  instances_primary_range  = "10.0.0.0/20",
  pods_secondary_range     = "10.1.0.0/16",
  services_secondary_range = "10.2.0.0/20",
}

# VPC peering information for existing VPC to peer with.
vpc_peering_config = {
  enabled           = true
  peer_vpc_name     = "<PEER_VPC_NAME>"
  peer_subnet_names = ["<PEER_SUBNET_NAME>"]
}

# Configuration for GPU nodes.
gpu_node_config = {
  machine_type     = "n1-standard-4"
  min_gpu_nodes    = 1
  max_gpu_nodes    = 10
  accelerator_type = "nvidia-tesla-t4"
  node_zones       = ["us-west1-a", "us-west1-b"]
}

# API key used to identify the company to Exafunction.
api_key = "<API_KEY>"

# Version of Exafunction Helm chart to install.
exafunction_chart_version = "<CHART_VERSION>"
