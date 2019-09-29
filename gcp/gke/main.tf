resource "google_container_cluster" "primary" {
  name               = var.name
  initial_node_count = 1
  location           = var.location

  node_config {
	machine_type = var.machine_type
    
    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

output "name" {
  value = google_container_cluster.primary.name
}

variable "name" {}

variable "location" {
  default = "europe-west2-a"
}

variable "machine_type" {
  default = "n1-standard-1"
}
