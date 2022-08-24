provider "google" {
  project = var.project
  region  = var.region
}

resource "google_storage_bucket" "terraform_state" {
  name        = var.bucket
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}
