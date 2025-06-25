terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.41.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("files/access-key.json")
  zone = var.zone
}

resource "google_storage_bucket" "main_bucket" {
  name     = var.bucket_name
  location = var.bucket_location
  project  = var.project_id

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
  storage_class = "STANDARD"

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}
