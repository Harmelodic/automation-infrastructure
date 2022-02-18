resource "google_folder" "management" {
  display_name = "Management"
  parent       = data.google_organization.harmelodic_com.name
}
