variable "unique_suffix" {
  description = "Unique suffix to add to resources. Useful if trying to spin up multiple deployments of Exafunction."
  type        = string
}

variable "vpc_self_link" {
  description = "Self link for the Exafunction VPC."
  type        = string
}

variable "peer_vpc_self_link" {
  description = "Self link for the peer VPC."
  type        = string
}

variable "peer_subnet_ip_ranges" {
  description = "List of IP ranges the Exafunction VPC should accept incoming connections from."
  type        = list(string)
}
