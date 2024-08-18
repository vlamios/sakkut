resource "yandex_vpc_network" "default" {
  name   = "default" 
  labels = "${var.labels}"
}

resource "yandex_vpc_subnet" "default" {
  description    = "Subnet in ru-central1-a availability zone"
  name           = "subnet-a"
  zone           = var.prefered_zones[0]
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["10.101.111.0/24"]
  labels         = "${var.labels}"
}

resource "yandex_dns_zone" "project_domain" {
  name             = "${var.project_domain_name}"
  description      = "external DNS zone"
  zone             = "${var.project_domain_zone}."
  public           = true
  labels           = "${var.labels}"
}

resource "yandex_dns_recordset" "wildcard" {
  zone_id = "${yandex_dns_zone.project_domain.id}"
  name    = "*"
  type    = "A"
  ttl     = 300
  data    = [var.outer_server_ip]
}

resource "yandex_dns_recordset" "commercial-at" {
  zone_id = "${yandex_dns_zone.project_domain.id}"
  name    = "@"
  type    = "A"
  ttl     = 300
  data    = [var.outer_server_ip]
}
