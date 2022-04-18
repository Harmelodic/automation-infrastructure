resource "google_service_account" "automation" {
  project      = google_project.automation.project_id
  account_id   = "automation"
  display_name = "automation"
  description  = "Harmelodic Organisation Automation Service Account"
}

resource "google_organization_iam_member" "automation_organisation_perms" {
  for_each = toset([
    "roles/billing.projectManager",
    "roles/editor",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.organizationViewer",
    "roles/resourcemanager.projectCreator",
  ])

  member = "serviceAccount:${google_service_account.automation.email}"
  org_id = data.google_organization.harmelodic_com.org_id
  role   = each.key
}

resource "google_billing_account_iam_member" "automation_billing_perms" {
  for_each = toset([
    "roles/billing.user",
    "roles/billing.viewer",
  ])

  billing_account_id = data.google_billing_account.my_billing_account.id
  member             = "serviceAccount:${google_service_account.automation.email}"
  role               = each.key
}
