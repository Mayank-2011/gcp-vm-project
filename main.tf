terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region = "us-central1"
  zone = "us-central1-a"
}

module "networking" {
  source = "./modules/networking"
  project_id = var.project_id
  region = "us-central1"
  network_name = "terraform-network"
}

moved {
  from = google_compute_network.vpc_network
  to   = module.networking.google_compute_network.vpc_network
}

moved {
  from = google_compute_subnetwork.subnet
  to   = module.networking.google_compute_subnetwork.subnet
}

moved {
  from = google_compute_firewall.web_firewall
  to   = module.networking.google_compute_firewall.web_firewall
}

resource "google_project_service" "secret_manager" {
  service = "secretmanager.googleapis.com"
  disable_on_destroy = false
}
