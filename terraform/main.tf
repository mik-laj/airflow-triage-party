provider "google" {}

data google_client_config "current" {}

# Variables
variable "docker_image_name" {
  type = string
  description = "Docker image name"
  default = "triage-party"
}

variable "docker_image_tag" {
  type = string
  description = "Docker image tag"
  default = "latest"
}

variable "github_token" {
  type = string
  description = "Github Token"
}

# Configuration
locals {
  db_location = "europe-west1"
  cloud_run_location = "europe-west4"
  project_id = data.google_client_config.current.project
}

# Cloud SQL Instance
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  name   = "airflow-triage-party-${random_id.db_name_suffix.hex}"
  project = local.project_id

  region = local.db_location
  database_version = "POSTGRES_12"

  settings {
    # Smallest instance
    # See: https://cloud.google.com/sql/pricing#pg-pricing
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = "tp"
  instance = google_sql_database_instance.instance.name
}

resource "random_password" "db_password" {
  length = 16
}

resource "google_sql_user" "user" {
  name     = "cloud-run-user"
  instance = google_sql_database_instance.instance.name
  password = random_password.db_password.result
}

# Cloud Run service
resource "google_cloud_run_service" "default" {
  name     = "airflow-triage-party-srv"
  # See: https://cloud.google.com/run/docs/locations
  location = local.cloud_run_location

  template {
    spec {
      containers {
        image = "gcr.io/${local.project_id}/${var.docker_image_name}:${var.docker_image_tag}"
        env {
          name = "GITHUB_TOKEN"
          value = var.github_token
        }
        env {
          name = "PERSIST_BACKEND"
          value = "cloudsql"
        }

        env {
          name = "PERSIST_PATH"
          value = "host=${local.project_id}:${local.db_location}:${google_sql_database_instance.instance.name} user=${google_sql_user.user.name} password=${random_password.db_password.result} dbname=${google_sql_database.database.name}"
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "5"
        "run.googleapis.com/cloudsql-instances" = "${local.project_id}:${local.db_location}:${google_sql_database_instance.instance.name}"
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
  autogenerate_revision_name = true
}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

# Outputs
output "cloud_run_url" {
  value = "${google_cloud_run_service.default.status[0].url}"
}
