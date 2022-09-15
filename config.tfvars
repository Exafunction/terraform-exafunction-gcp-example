# GCP project ID.
project = "<GCP_PROJECT>"

# Region for GCP resources.
region = "us-west1"

# Region and IP ranges for the Exafunction VPC.
vpc_ip_range_config = {
  nodes_ip_range    = "10.0.0.0/20",
  pods_ip_range     = "10.1.0.0/16",
  services_ip_range = "10.2.0.0/20",
}

# Allow ssh into instances in the VPC.
allow_ssh = true

# Runner pool configuration.
runner_pools = [
  {
    suffix            = "gpu"
    machine_type      = "n1-standard-4"
    capacity_type     = "ON_DEMAND"
    disk_size         = 100
    min_size          = 1
    max_size          = 10
    accelerator_count = 1
    accelerator_type  = "nvidia-tesla-t4"
    node_zones        = ["us-west1-a", "us-west1-b"]
    additional_taints = []
    additional_labels = {}
  }
]

# VPC peering information for existing VPC to peer with.
vpc_peering_config = {
  enabled           = true
  peer_vpc_name     = "<PEER_VPC_NAME>"
  peer_subnet_names = ["<PEER_SUBNET_NAME>"]
}

# API key used to identify the company to Exafunction.
api_key = "<API_KEY>"

# ExaDeploy component images.
scheduler_image         = "gcr.io/exafunction/scheduler:<SCHEDULER_IMAGE_TAG>"
module_repository_image = "gcr.io/exafunction/module_repository:<MODULE_REPOSITORY_IMAGE_TAG>"
runner_image            = "gcr.io/exafunction/runner@sha256::<RUNNER_IMAGE_SHA>"

# ExaDeploy Helm Chart version.
exadeploy_helm_chart_version = "<CHART_VERSION>"
