data "google_organization" "harmelodic_com" {
  domain = "harmelodic.com"
}
#
#resource "google_org_policy_policy" "disable_service_account_key_creation" {
#  name = "organizations/${data.google_organization.harmelodic_com.id}/policies/iam.disableServiceAccountCreation"
#  parent = "organizations/${data.google_organization.harmelodic_com.id}"
#
#  spec {
#    rules {
#      enforce = "TRUE"
#    }
#  }
#}