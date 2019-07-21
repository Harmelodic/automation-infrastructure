resource "google_sql_database_instance" "master" {
  name = var.name
  database_version = var.database_version

  settings {
    tier = var.tier
  }
}

variable "name" {}

variable "database_version" {
  default = "MYSQL_5_7"
}

variable "region" {
  default = "europe-west2"
}

variable "tier" {
  default = "db-f1-micro"
}