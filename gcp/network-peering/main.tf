resource "google_compute_network_peering" "network-to-peer-network" {
  name         = "${var.network}--${var.peer_network}"
  network      = var.network_link
  peer_network = var.peer_network_link
}

resource "google_compute_network_peering" "peer-network-to-network" {
  name         = "${var.peer_network}--${var.network}"
  network      = var.peer_network_link
  peer_network = var.network_link
}

variable "network" {}
variable "network_link" {}
variable "peer_network" {}
variable "peer_network_link" {}