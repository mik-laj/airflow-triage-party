terraform {
  backend "gcs" {
    bucket  = "airflow-triage-party-tf-state"
    prefix  = "terraform/state"
  }
}