variable "project" {
  description = "GCP project ID."
  type = string

  validation {
    condition     = can(regex("^[a-z0-9\\-]{6,30}$", var.project))
    error_message = "Invalid GCP project ID format."
  }
}

variable "region" {
  description = "Region for existing GKE cluster."
  type        = string

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "Invalid GCP region format."
  }
}

variable "api_key" {
  description = "API key used to identify the user to the Exafunction API."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.api_key))
    error_message = "Invalid API key format."
  }
}

variable "exafunction_chart_version" {
  description = "Version of the Exafunction Helm chart to install."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.exafunction_chart_version))
    error_message = "Invalid Helm chart version format."
  }
}

variable "remote_state_config" {
  description = "Configuration parameters for the cluster Terraform's remote state (GCS)."
  type = object({
    bucket = string
    prefix = string
  })

  validation {
    condition     = can(regex("^[a-z0-9\\.\\-]{3,63}$", var.remote_state_config.bucket))
    error_message = "Invalid GCS bucket name format in `remote_state_config`."
  }
}

variable "values_file_path" {
  description = "Path to values YAML file to pass to exafunction-cluster Helm chart. Format should match values.yaml.example."
  type        = string
}
