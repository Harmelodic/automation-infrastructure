module "cloudsql" {
  source   = "./cloudsql"
  name     = "example"
  project  = "example-project"
}

module "firewall" {
  source   = "./firewall"
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
  source  = "./gke"
  name    = "example-gke"
  project = "example-project" 
}

module "iam-policy" {
  source  = "./iam-policy"
  project = "example-project"
  owners  = [
    "matt@harmelodic.com"
  ]
}

module "iam-role" {
  source      = "./iam-role"
  permissions = ["compute.networks.get"]
  project     = "example-project"
  role_id     = "exampleUser"
  title       = "Example User"
}

module "network-peering" {
  source               = "./network-peering"
  network              = "example-network"
  network_project      = "example-project"
  peer_network         = "example-network-two"
  peer_network_project = "example-project-two"
}