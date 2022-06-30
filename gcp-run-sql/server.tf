resource "google_cloud_run_service" "server" {
  provider = google
  name     = local.name
  location = data.google_client_config.current.region
  template {
    spec {
      containers {
        image = local.image_name
      }
    }
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

# 未承認の呼び出しも許可する
resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.server.location
  project  = google_cloud_run_service.server.project
  service  = google_cloud_run_service.server.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
