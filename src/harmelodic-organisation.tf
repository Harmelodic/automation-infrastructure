data "google_organization" "harmelodic_com" {
  domain = "harmelodic.com"
}

resource "google_organization_iam_member" "automation_organisation_perms" {
  for_each = toset([
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.organizationViewer",
    "roles/resourcemanager.projectCreator",
  ])

  member = google_service_account.automation.member
  org_id = data.google_organization.harmelodic_com.org_id
  role   = each.key
}
