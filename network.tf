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

resource "yandex_dns_recordset" "project_domain" {
  zone_id = "${yandex_dns_zone.project_domain.id}"
  name    = "${var.project_domain_zone}."
  type    = "A"
  ttl     = 300
  data    = [var.outer_server_ip]
}

resource "yandex_dns_recordset" "postbox__domainkey_project_domain" {
  zone_id = "${yandex_dns_zone.project_domain.id}"
  name    = "postbox._domainkey.${var.project_domain_zone}."
  type    = "TXT"
  ttl     = 60
  data    = [
      <<-EOT
          ( "v=DKIM1;h=sha256;k=rsa; "
          
          "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjLguV+X+2nyeiEFtY94cpiGNTNDxjjmDZuOs0YmB4GFlxiln6JgoWXhnceevm96zx9wm7Haxj1pm1wuyRiUGnMbWumAlzY/oCeOhu2HLMcXObB9wHwypyipTARJSR/p5zT4EK9uWgPt8bbJUV5lap9x"
          
          "747qIjYj2FOmeFI2y/MdNmn+C8/+VVqfxL8i9wIZb7CmO4ECk4YP5YBh1YF3aGZyf2LBFTn7Sy634FiWVkv3MHp+XUejznH36BEDUTJethMr3WMp2mwaBEEjs9lLJMHfwhqAUL1gj72736m+FDbUliE0kGqxA3yWpzd9Pq2zKDFJg8Xn5LOnoULKw7k8bowIDAQAB" )
      EOT
  ]
}

# resource "yandex_dns_recordset" "_dmarc_project_domain" {
#   zone_id = "${yandex_dns_zone.project_domain.id}"
#   name    = "_dmarc.${var.project_domain_zone}."
#   type    = "TXT"
#   ttl     = 60
#   data    = [
#       <<-EOT
#           "v=DMARC1; p=none"
#       EOT
#   ]
# }

# resource "yandex_dns_recordset" "wildcard" {
#   zone_id = "${yandex_dns_zone.project_domain.id}"
#   name    = "*"
#   type    = "A"
#   ttl     = 300
#   data    = [var.outer_server_ip]
# }

# resource "yandex_dns_recordset" "commercial-at" {
#   zone_id = "${yandex_dns_zone.project_domain.id}"
#   name    = "@"
#   type    = "A"
#   ttl     = 300
#   data    = [var.outer_server_ip]
# }
