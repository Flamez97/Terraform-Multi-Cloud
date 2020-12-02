#----Google Compute----

provider "google" {
  credentials   = file("peak-hangout.json")
  project       = "peak-hangout-267916"
  region        = "us-central1"
}

resource "google_compute_network" "vpc1" {
  name       = "flamez-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_instance" "instance1" {
  name         = "burgundy"
  machine_type = "n1-standard-1"
  zone         = "us-east4-a"

  boot_disk {
    initialize_params {
      image    = "Ubuntu/Ubuntu-16.04-LTS"
    }
  }

  network_interface {
    network = google_compute_network.vpc1

    access_config {
      // Ephemeral IP
    }
  }
}
