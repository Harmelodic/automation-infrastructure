resource "google_iam_workload_identity_pool" "automation" {
  provider                  = google-beta
  project                   = google_project.automation.project_id
  workload_identity_pool_id = "automation"
  display_name              = "Automation"
  description               = "A pool for automation agents"
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "automation_github" {
  project                            = google_project.automation.project_id
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.automation.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name                       = "GitHub"
  description                        = "GitHub Provider for GitHub CI/CD automation"
  disabled                           = false

  attribute_mapping = {
    "attribute.aud"  = "assertion.aud",
    "google.subject" = "assertion.sub"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

locals {
  audience = "https://github.com/Harmelodic"
}

resource "google_service_account_iam_member" "automation_workload_identity_user" {
  service_account_id = google_service_account.automation.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.automation.name}/attribute.aud/${local.audience}"
}
