resource "google_service_account" "automation" {
  project      = google_project.automation.project_id
  account_id   = "automation"
  display_name = "automation"
  description  = "Harmelodic Organisation Automation Service Account"
}

resource "google_project_iam_member" "automation" {
  project = google_project.automation.id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.automation.email}"
}
