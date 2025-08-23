# In order to use a 3rd party system with Google Service Accounts, it's best to use:
# Workload Identity Federation.

# This file sets up Workload Identity Federation with GitHub, in order to use GitHub Actions to provision Google Cloud
# infrastructure.

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool
# "Represents a collection of external workload identities. You can define IAM policies to grant these identities
# access to Google Cloud resources."
# In this case, this Workload Identity Pool is for identities used by GitHub (in GitHub Actions).
resource "google_iam_workload_identity_pool" "github" {
  project                   = google_project.automation.project_id
  workload_identity_pool_id = "github"
  display_name              = "GitHub"
  description               = "A pool for identities used by GitHub workloads (e.g. Actions)"
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
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-oidc"
  display_name                       = "GitHub OIDC"
  description                        = "GitHub OIDC Provider for Workload Identity Federation"
  disabled                           = false

  # GitHub OIDC Token assertions: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token
  attribute_mapping = {
    # attribute.<custom>         = Common Expression Language (made up of GitHub's OIDC Token assertions)
    "attribute.owner"            = "assertion.repository_owner"
    "attribute.owner_and_branch" = "assertion.repository_owner + '::' + assertion.ref_type + '::' + assertion.ref",
    "google.subject"             = "assertion.sub"
  }

  # Limits the identities that come from GitHub OIDC (pool provider) to only those matching the condition
  # checkov:skip=CKV_GCP_125:9994373 is the safe & fixed user ID for Harmelodic. Don't want to limit further.
  attribute_condition = "assertion.repository_owner_id == 9994373"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}
