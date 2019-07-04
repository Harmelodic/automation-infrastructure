resource "google_compute_network_peering" "network-to-peer-network" {
  name         = "${var.network}--${var.peer_network}"
  network      = "https://www.googleapis.com/compute/v1/projects/${var.network_project}/global/networks/${var.network}"
  peer_network = "https://www.googleapis.com/compute/v1/projects/${var.peer_network_project}/global/networks/${var.peer_network}"
}

resource "google_compute_network_peering" "peer-network-to-network" {
  name         = "${var.peer_network}--${var.network}"
  network      = "https://www.googleapis.com/compute/v1/projects/${var.peer_network_project}/global/networks/${var.peer_network}"
  peer_network = "https://www.googleapis.com/compute/v1/projects/${var.network_project}/global/networks/${var.network}"
}

variable "network" {}
variable "network_project" {}
variable "peer_network" {}
variable "peer_network_project" {}
