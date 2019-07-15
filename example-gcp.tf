terraform {
  backend "gcs" {
    bucket = "example-tf-state"
    prefix = "terraform/example-state"
  }
}

module "cloudsql" {
  source   = "./gcp/cloudsql"
  name     = "example"
  project  = "example-project"
}

module "firewall" {
  source   = "./gcp/firewall"
  name     = "example"
  network  = "example-network"
  project  = "example-project"
  protocol = "TCP"
  ports    = [
    "80", "443"
  ]
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "example"
  ]
}

module "gke" {
  source  = "./gcp/gke"
  name    = "example-gke"
  project = "example-project" 
}

module "iam-policy" {
  source  = "./gcp/iam-policy"
  project = "example-project"
  owners  = [
    "matt@harmelodic.com"
  ]
}

module "iam-role" {
  source      = "./gcp/iam-role"
  permissions = ["compute.networks.get"]
  project     = "example-project"
  role_id     = "exampleUser"
  title       = "Example User"
}

module "network-peering" {
  source               = "./gcp/network-peering"
  network              = "example-network"
  network_project      = "example-project"
  peer_network         = "example-network-two"
  peer_network_project = "example-project-two"
}