resource "google_container_cluster" "primary" {
  name               = var.name
  initial_node_count = 3
  location           = var.location
  project            = var.project

  cluster_autoscaling {
    enabled = true

    resource_limits {
      resource_type = "cpu"
      minimum = "1"
      maximum = "16"
    }

    resource_limits {
      resource_type = "memory"
      minimum = "1"
      maximum = "64"
    }
  }

  node_config {
	  machine_type = "n1-standard-1"
    
    metadata {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

variable "project" {}
variable "name" {}

variable "location" {
  default = "europe-west2-a"
}