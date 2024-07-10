resource "google_service_account" "automation" {
  project      = google_project.automation.project_id
  account_id   = "automation"
  display_name = "automation"
  description  = "Automation Service Account"
}

# Allows automation account to be used as an identity for any GitHub workload.
# Though only workloads that meet all the criteria:
# - Repositories owned by Harmelodic
# - Using the `main` branch (meaning other branches/refs can't provision infrastructure)
resource "google_service_account_iam_member" "automation_workload_identity_user" {
  service_account_id = google_service_account.automation.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.owner_and_branch/Harmelodic::branch::refs/heads/main"
}
