locals {
  name       = "terraform-test-${terraform.workspace}"
  image_name = "${data.google_client_config.current.region}-docker.pkg.dev/${data.google_client_config.current.project}/${google_artifact_registry_repository.repo.name}/server"
}

data "google_client_config" "current" {}
