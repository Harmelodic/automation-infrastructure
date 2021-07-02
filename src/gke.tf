//resource "google_container_cluster" "main" {
//  name              = terraform.workspace
//  cluster_ipv4_cidr = "10.0.0.0/14"
//
//  addons_config {
//
//  }
//}
//
//resource "google_service_account" "node_pool" {
//  account_id   = "${terraform.workspace}-node-pool"
//  display_name = "GKE Node Pool Service Account"
//}
//
//resource "google_container_node_pool" "main_node_pool" {
//  name       = terraform.workspace
//  cluster    = google_container_cluster.main.name
//  node_count = 1
//
//  management {
//    auto_repair  = true
//    auto_upgrade = true
//  }
//
//  upgrade_settings {
//    max_surge       = 2
//    max_unavailable = 1
//  }
//
//  node_config {
//    machine_type    = var.gke_node_pool_machine_type
//    service_account = google_service_account.node_pool.email
//
//    oauth_scopes = [
//      "https://www.googleapis.com/auth/cloud-platform"
//    ]
//  }
//}
//
//variable "gke_node_pool_machine_type" {
//  default     = "g1-small"
//  description = "Machine size for GKE node pool"
//  sensitive   = false
//  type        = string
//}
