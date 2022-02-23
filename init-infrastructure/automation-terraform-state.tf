resource "google_kms_key_ring" "automation" {
  project  = google_project.automation.id
  location = local.location
  name     = "automation"
}

resource "google_kms_crypto_key" "terraform_state" {
  key_ring = google_kms_key_ring.automation.id
  name     = "terraform-state"
}

resource "google_storage_bucket" "terraform_state" {
  project                     = google_project.automation.id
  name                        = "harmelodic-terraform-state"
  location                    = upper(local.location)
  force_destroy               = false
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"

  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform_state.id
  }
}
