resource "google_service_account" "automation_for_pull_requests" {
  project      = google_project.automation.project_id
  account_id   = "automation-for-pull-requests"
  display_name = "automation-for-pull-requests"
  description  = "Automation Service Account for Pull Requests"
}

# Allows automation-for-pull-requests account to be used as an identity for any GitHub workload.
# Though only workloads that meet all the criteria:
# - Repositories owned by Harmelodic
# - On any branch (though it's intended to be used for pull requests)
resource "google_service_account_iam_member" "automation_for_pull_requests_workload_identity_user" {
  service_account_id = google_service_account.automation_for_pull_requests.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.owner/Harmelodic"
}
