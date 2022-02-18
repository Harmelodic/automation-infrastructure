resource "google_folder" "operations" {
  display_name = "Operations"
  parent       = data.google_organization.harmelodic_com.name
}

resource "google_folder_iam_member" "automation" {
  folder  = google_folder.operations.id
  member  = "serviceAccount:${google_service_account.automation.email}"
  role    = "roles/owner"
}
