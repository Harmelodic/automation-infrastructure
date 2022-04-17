resource "google_folder" "automation" {
  display_name = "Automation"
  parent       = data.google_organization.harmelodic_com.id
}
