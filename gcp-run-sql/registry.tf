resource "google_artifact_registry_repository" "repo" {
  provider      = google-beta
  location      = data.google_client_config.current.region
  repository_id = local.name
  format        = "DOCKER"
}

resource "null_resource" "build_push" {
  provisioner "local-exec" {
    command = file("./app/cmd/build-push.sh")
    environment = {
      IMAGE_NAME = local.image_name
    }
    on_failure = fail
  }
}
