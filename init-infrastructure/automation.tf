resource "random_integer" "automation_project_suffix" {
  max = 1
  min = 999999
}

resource "google_project" "automation" {
  name                = "automation"
  project_id          = "automation-${random_integer.automation_project_suffix.result}"
  folder_id           = google_folder.management.id
  auto_create_network = false
}

resource "google_service_account" "automation" {
  project      = google_project.automation.id
  account_id   = "automation"
  display_name = "automation"
  description  = "Harmelodic Organisation Automation Service Account"
}

resource "google_project_iam_member" "automation" {
  project = google_project.automation.id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.automation.email}"
}
