resource "google_service_account" "automation" {
  project      = google_project.automation.project_id
  account_id   = "automation"
  display_name = "automation"
  description  = "Harmelodic Organisation Automation Service Account"
}

resource "google_organization_iam_member" "automation_organisation_perms" {
  for_each = toset([
    "roles/billing.projectManager",
    "roles/billing.viewer",
    "roles/editor",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.organizationViewer",
  ])
  member = "serviceAccount:${google_service_account.automation.email}"
  org_id = data.google_organization.harmelodic_com.org_id
  role   = each.key
}
