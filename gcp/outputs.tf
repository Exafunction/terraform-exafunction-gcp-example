output "project" {
  description = "GCP project ID."
  value       = var.project
}

output "region" {
  description = "Region of the GKE cluster."
  value       = var.region
}

output "cluster_name" {
  description = "Name of the GKE cluster."
  value       = module.exafunction_cluster.cluster_name
}

output "exafunction_network" {
  description = "Exafunction network module."
  value       = module.exafunction_network
}

output "exafunction_cluster" {
  description = "Exafunction cluster module."
  value       = module.exafunction_cluster
}

output "exafunction_module_repo_backend" {
  description = "Exafunction module repository backend module."
  value       = module.exafunction_module_repo_backend
  sensitive   = true
}

output "exafunction_peering" {
  description = "Exafunction peering module."
  value       = module.exafunction_peering
}
