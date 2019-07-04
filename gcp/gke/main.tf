resource "google_container_cluster" "primary" {
  name               = var.name
  initial_node_count = 1
  location           = var.location
  project            = var.project

  node_config {
	  machine_type = "n1-standard-1"
    
    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

variable "name" {}
variable "project" {}

variable "location" {
  default = "europe-west2-a"
}