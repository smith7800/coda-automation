locals {
  network_region = var.network_region
}

resource "google_compute_network" "default" {
  name = var.network_name
}

resource "google_compute_subnetwork" "default" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = local.network_region
  network       = google_compute_network.default.self_link
}

resource "google_compute_firewall" "coda_daemon_ingress" {
  name    = "${var.network_name}-daemon-ingress"
  network = google_compute_network.default.name

  source_ranges = [ "0.0.0.0/0" ]

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["10000-11000", "8303", "8302"]
  }

  allow {
    protocol = "udp"
    ports    = ["10000-11000", "8303", "8302"]
  }

  source_tags = ["coda-daemon"]
}

