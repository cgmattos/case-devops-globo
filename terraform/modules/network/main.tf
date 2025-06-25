resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_vpc_access_connector" "connector" {
  name          = "${var.vpc_name}-connector"
  region        = var.region
  network       = google_compute_network.vpc.name
  max_instances = 6
  min_instances = 2

  ip_cidr_range = var.connector_cidr
}