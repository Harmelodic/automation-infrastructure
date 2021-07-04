resource "google_container_cluster" "gke_cluster" {
  description                 = "GKE Cluster for environment: ${terraform.workspace}"
  enable_binary_authorization = false
  enable_intranode_visibility = false
  enable_legacy_abac          = false
  enable_shielded_nodes       = true
  enable_tpu                  = false
  initial_node_count          = 1
  location                    = var.gke_location
  logging_service             = "logging.googleapis.com/kubernetes"
  min_master_version          = "1.20.6"
  name                        = terraform.workspace
  network                     = google_compute_network.gke.self_link
  remove_default_node_pool    = true
  resource_labels             = {
    environment = terraform.workspace
  }
  subnetwork                  = google_compute_subnetwork.gke.self_link

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }
  }

  cluster_autoscaling {
    enabled = false
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "cluster-secondary-range"
    services_secondary_range_name = "services-secondary-range"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  private_cluster_config {
    enable_private_endpoint = false
  }

  network_policy {
    enabled = false
  }

  release_channel {
    channel = "RAPID"
  }

  workload_identity_config {
    identity_namespace = "${var.project}.svc.id.goog"
  }
}

resource "google_container_node_pool" "gke_node_pool" {
  cluster            = google_container_cluster.gke_cluster.name
  initial_node_count = 1
  location           = var.gke_location
  name               = terraform.workspace
  node_count         = 1
  node_locations     = var.gke_node_locations

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    disk_size_gb    = 100
    disk_type       = "pd-standard"
    image_type      = "cos_containerd"
    labels          = {
      environment = terraform.workspace
    }
    local_ssd_count = 0
    machine_type    = var.gke_node_pool_machine_type
    metadata        = {
      disable-legacy-endpoints = true
    }
    preemptible     = false
    service_account = google_service_account.gke_node_pool.email
    tags            = [
      terraform.workspace
    ]

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }
  }

  upgrade_settings {
    max_surge       = 2
    max_unavailable = 1
  }
}

resource "google_compute_network" "gke" {
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
  description                     = "Compute Network for GKE nodes"
  name                            = "${terraform.workspace}-gke"
  routing_mode                    = "GLOBAL"
}

resource "google_compute_subnetwork" "gke" {
  name          = "${terraform.workspace}-gke-subnetwork"
  ip_cidr_range = "10.255.0.0/16"
  region        = var.region
  network       = google_compute_network.gke.id

  secondary_ip_range {
    range_name    = "cluster-secondary-range"
    ip_cidr_range = "10.0.0.0/10"
  }

  secondary_ip_range {
    range_name    = "services-secondary-range"
    ip_cidr_range = "10.64.0.0/10"
  }
}

resource "google_service_account" "gke_node_pool" {
  account_id   = "${terraform.workspace}-node-pool"
  description  = "The default service account for pods to use"
  display_name = "GKE Node Pool Service Account"
}

resource "google_project_iam_member" "gke_node_pool" {
  member = "serviceAccount:${google_service_account.gke_node_pool.email}"
  role   = "roles/viewer"
}

variable "gke_node_pool_machine_type" {
  default     = "g1-small"
  description = "Machine size for GKE node pool"
  sensitive   = true
  type        = string
}

variable "gke_location" {
  default     = "europe-north1"
  description = "Location of where GKE cluster will be created"
  sensitive   = true
  type        = string
}

variable "gke_node_locations" {
  description = "The list of zones in which the node pool's nodes should be located"
  sensitive   = true
  type        = list(string)
}
