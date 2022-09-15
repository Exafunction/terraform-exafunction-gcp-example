provider "google" {
  project = var.project
  region  = var.region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  bucket_name = "terraform-exafunction-${random_string.suffix.result}"
}

resource "google_storage_bucket" "terraform_state" {
  name          = local.bucket_name
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}
