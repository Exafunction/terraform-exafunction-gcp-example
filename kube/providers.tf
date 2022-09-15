provider "google" {
  project = var.project
  region  = var.region
}

data "terraform_remote_state" "cloud" {
  backend = "gcs"
  config = {
    bucket = var.remote_state_config.bucket
    prefix = var.remote_state_config.prefix
  }
}

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster" {
  name     = data.terraform_remote_state.cloud.outputs.cluster_name
  location = data.terraform_remote_state.cloud.outputs.region
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.cluster.endpoint}"
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,
  )
  token = data.google_client_config.provider.access_token
}

provider "helm" {
  kubernetes {
    host = "https://${data.google_container_cluster.cluster.endpoint}"
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,
    )
    token = data.google_client_config.provider.access_token
  }
}
