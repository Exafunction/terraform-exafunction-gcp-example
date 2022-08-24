output "bucket" {
  description = "Name of the S3 bucket to use for storing Terraform state."
  value       = google_storage_bucket.terraform_state.name
}
