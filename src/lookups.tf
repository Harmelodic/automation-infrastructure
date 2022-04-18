data "google_billing_account" "my_billing_account" {
  display_name = "My Billing Account"
  open         = true
}

data "google_organization" "harmelodic_com" {
  domain = "harmelodic.com"
}