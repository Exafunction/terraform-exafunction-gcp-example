resource "google_compute_network_peering" "exafunction_to_peer" {
  name         = "exafunction-to-peer${var.unique_suffix}"
  network      = var.vpc_self_link
  peer_network = var.peer_vpc_self_link
}

resource "google_compute_network_peering" "peer_to_exafunction" {
  name         = "peer-to-exafunction${var.unique_suffix}"
  network      = var.peer_vpc_self_link
  peer_network = var.vpc_self_link
}

resource "google_compute_firewall" "rules" {
  name        = "exafunction-ingress${var.unique_suffix}"
  network     = var.vpc_self_link
  description = "Ingress from peer VPC to Exafunction VPC"

  allow {
    protocol = "tcp"
  }

  source_ranges = var.peer_subnet_ip_ranges
}
