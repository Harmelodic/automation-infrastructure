resource "google_service_account" "terraform_verifier" {
  project      = google_project.automation.project_id
  account_id   = "terraform-verifier"
  display_name = "terraform-verifier"
  description  = "Service Account for doing terraform verification"
}

# Allows terraform-verifier account to be used as an identity for any GitHub workload.
# Though only workloads that meet all the criteria:
# - Repositories owned by Harmelodic
# - On any branch
resource "google_service_account_iam_member" "terraform_verifier_workload_identity_user" {
  service_account_id = google_service_account.terraform_verifier.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.owner/Harmelodic"
}
