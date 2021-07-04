resource "google_project_service" "apis" {
  for_each = toset([
    "cloudapis.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "stackdriver.googleapis.com",
    "storage-component.googleapis.com",
    "storage.googleapis.com"
  ])

  disable_dependent_services = true
  disable_on_destroy         = true
  service = each.key
}
