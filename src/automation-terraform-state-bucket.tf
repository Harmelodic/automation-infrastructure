resource "google_kms_key_ring" "automation" {
  project  = google_project.automation.project_id
  location = local.location
  name     = "automation"
}

resource "google_kms_crypto_key" "terraform_state" {
  key_ring = google_kms_key_ring.automation.id
  name     = "terraform-state"
}

resource "google_kms_crypto_key_iam_binding" "terraform_state" {
  crypto_key_id = google_kms_crypto_key.terraform_state.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${google_project.automation.number}@gs-project-accounts.iam.gserviceaccount.com"
  ]
}

resource "google_storage_bucket" "terraform_state" {
  project                     = google_project.automation.project_id
  name                        = "harmelodic-tfstate"
  location                    = upper(local.location)
  force_destroy               = false
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"

  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform_state.id
  }

  depends_on = [
    google_kms_crypto_key_iam_binding.terraform_state
  ]
}

resource "google_storage_bucket_iam_member" "automation_terraform_state_perms" {
  bucket = google_storage_bucket.terraform_state.name
  member = google_service_account.automation.member
  role   = "roles/storage.admin"
}

resource "google_storage_bucket_iam_member" "automation_for_pull_requests_terraform_state_perms" {
  bucket = google_storage_bucket.terraform_state.name
  member = google_service_account.automation_for_pull_requests.member
  role   = "roles/storage.objectUser"
}
