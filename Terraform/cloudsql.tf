resource "random_id" "db_suffix" {
  byte_length = 2
}

module "sql-db" {
  source           = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version          = "~> 22.0"
  project_id       = "${var.gcp_project_id}"
  name             = "db-${random_id.db_suffix.hex}"
  database_version = "POSTGRES_15"
  region           = "us-central1"
}

resource "google_dns_record_set" "db" {
  name         = "db.${google_dns_managed_zone.internal.dns_name}"
  type         = "A"
  ttl          = "60"
  managed_zone = google_dns_managed_zone.internal.name
  rrdatas      = [module.sql-db.instance_first_ip_address]
}

