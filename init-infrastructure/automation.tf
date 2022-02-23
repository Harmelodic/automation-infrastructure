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

resource "google_project_service" "apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "storage.googleapis.com",
    "sts.googleapis.com",
  ])

  disable_dependent_services = true
  disable_on_destroy         = true
  service                    = each.key
}
