output "project" {
  description = "GCP project ID."
  value       = var.project
}

output "region" {
  description = "Region of the GKE cluster."
  value       = var.region
}

output "cluster_id" {
  description = "ID of the GKE cluster."
  value       = module.exafunction.cluster_id
}

output "vpc_name" {
  description = "Name of the VPC."
  value       = google_compute_network.vpc.name
}

output "vpc_self_link" {
  description = "Self link for the VPC."
  value       = google_compute_network.vpc.self_link
}
