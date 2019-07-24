resource "google_compute_firewall" "default" {
  name          = var.name
  network       = var.network
  source_ranges = var.source_ranges
  target_tags   = var.target_tags

  allow {
    protocol = var.protocol
    ports    = var.ports
  }
}

output "name" {
  value = google_compute_firewall.default.name
}

variable "name" {}
variable "network" {}
variable "protocol" {}

variable "ports" {
  default = []
}

variable "source_ranges" {
  default = []
}

variable "target_tags" {
  default = []
}