terraform {
  backend "gcs" {
    bucket = "example-tf-state"
    prefix = "terraform/example-state"
  }
}

provider "google" {
  project     = "example-project"
  region      = "europe-west2"
  zone        = "europe-west2-a"
}

module "cloudsql" {
  source   = "./gcp/cloudsql"
  name     = "example"
}

module "firewall" {
  source   = "./gcp/firewall"
  name     = "example"
  network  = "example-network"
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
}

module "iam-policy" {
  source  = "./gcp/iam-policy"
  owners  = [
    "user:matt@harmelodic.com"
  ]
}

module "iam-role" {
  source      = "./gcp/iam-role"
  permissions = ["compute.networks.get"]
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