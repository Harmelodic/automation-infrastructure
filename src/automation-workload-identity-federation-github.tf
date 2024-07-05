# In order to use a 3rd party system with Google Service Accounts, it's best to use:
# Workload Identity Federation.

# This file sets up Workload Identity Federation with GitHub, in order to use GitHub Actions to provision Google Cloud
# infrastructure.

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool
# "Represents a collection of external workload identities. You can define IAM policies to grant these identities
# access to Google Cloud resources."
# In this case, this Workload Identity Pool is for identities used by GitHub (in GitHub Actions).
resource "google_iam_workload_identity_pool" "automation" {
  project                   = google_project.automation.project_id
  workload_identity_pool_id = "automation"
  display_name              = "Automation"
  description               = "A pool for automation agents"
  disabled                  = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider
# "A configuration for an external identity provider"
# In this case:
# - Configuring GitHub as a "Workload Identity Pool Provider".
# - This "Workload Identity Pool Provider" is connected to the above "Workload Identity Pool".
# - A mapping is then made between GitHub's OIDC token "assertions" and Google's Workload Identity "attributes"
resource "google_iam_workload_identity_pool_provider" "automation_github" {
  project                            = google_project.automation.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.automation.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name                       = "GitHub"
  description                        = "GitHub Provider for GitHub CI/CD automation"
  disabled                           = false

  # GitHub OIDC Token Assertions:
  # https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token
  attribute_mapping = {
    # attribute.<custom> = GitHub OIDC Token Assertion
    "attribute.repository_owner" = "assertion.repository_owner",
    "google.subject"             = "assertion.sub"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Grants automation account to be a "Workload Identity User" for
resource "google_service_account_iam_member" "automation_workload_identity_user" {
  service_account_id = google_service_account.automation.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.automation.name}/attribute.repository_owner/Harmelodic"
}
