resource "random_integer" "automation_project_suffix" {
  min = 1
  max = 999999
}

resource "google_project" "automation" {
  name                = "automation"
  project_id          = "automation-${random_integer.automation_project_suffix.result}"
  folder_id           = google_folder.management.id
  billing_account     = data.google_billing_account.my_billing_account.id
  auto_create_network = false
}

resource "google_project_service" "automation_apis" {
  for_each = toset([
    "artifactregistry.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "storage.googleapis.com",
    "sts.googleapis.com"
  ])

  project                    = google_project.automation.id
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = true
}
