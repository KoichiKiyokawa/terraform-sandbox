resource "google_sql_database" "db" {
  provider = google
  name     = "${local.name}-1"
  instance = google_sql_database_instance.db-instance.id
}


resource "google_sql_database_instance" "db-instance" {
  provider            = google
  name                = "${local.name}-1"
  database_version    = "POSTGRES_14"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
  }
}
