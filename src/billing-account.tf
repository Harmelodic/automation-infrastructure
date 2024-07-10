data "google_billing_account" "my_billing_account" {
  display_name = "My Billing Account"
  open         = true
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
