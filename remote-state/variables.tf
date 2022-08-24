variable "project" {
  description = "GCP project ID."
  type    = string

  validation {
    condition     = can(regex("^[a-z0-9\\-]{6,30}$", var.project))
    error_message = "Invalid GCP project ID format."
  }
}

variable "region" {
  description = "Region for GCS bucket"
  type        = string

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "Invalid GCP region format."
  }
}

variable "bucket" {
  description = "Name of the GCS bucket to use for storing terraform state."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9\\.\\-]{3,63}$", var.bucket))
    error_message = "Invalid GCS bucket name format."
  }
}
