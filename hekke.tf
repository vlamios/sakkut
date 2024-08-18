resource "yandex_compute_instance" "hekke" {
  name        = "hekke"
  hostname    = "hekke"
  platform_id = "standard-v2"
  zone        = var.prefered_zones[0]
  labels      = "${var.labels}"
  allow_stopping_for_update = true
  resources {
    cores  = 2
    memory = 2
  //Guaranteed vCPU performance to allocate to the VM.
  //VMs with less than 100% guaranteed performance provide the specified performance level with possible temporary bursts up to 100%.
  //These VMs are suitable for tasks that do not require constant vCPU performance at 100%.
    core_fraction = 5
  }

  scheduling_policy {
  //A VM that runs for no more than 24 hours and can be terminated by Compute Cloud at any time.
  //Terminated VMs aren’t deleted and all the data they contain is retained.
  //To continue using a VM, restart it. Provided at a significant discount.
    preemptible = true
  }

  boot_disk {
    disk_id = "${yandex_compute_disk.hekke-disk.id}"
  }

  network_interface {
    subnet_id      = "${yandex_vpc_subnet.default.id}"
    ipv4           = true
    ipv6           = false
    nat_ip_address = "${yandex_vpc_address.hekke-ip.external_ipv4_address[0].address}"
    nat            = true
  }

  metadata = {
    motto              = "Protéger & servir"
    enable-oslogin     = false
    serial-port-enable = 0
    user-data          = "#cloud-config\nusers:\n  - name: osadmin\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApWWTuvKZPt5xICRvN16IZZ1pcP+a1pUfZvz/pC13ivyMbWvuywjay+CUr1To8TfqVoiEcPADkMOoAoMvI2TyJcPU5cNJdiqyRWNWSzABbhGCB5T0EvhhNXzkqWBLFOVpuy4UNYAr8y6tM1FLkToOt44uFmJlX8k1leeyAOjUU/O6VAOtBEllxoAtV6KliUWdS5UG3hzMXvPS1nFW05ZqtV8MxYRX4DcQI70M5pt1wWRdGgDpDYJv2uHiPAceLPUuslySP5yVU0O3OXz36XNqocx0DlVWGh4XNKEG8Zf4+9sdC+O9j3Mjr94VMBtzvr2sv3zeAAjtz16nYYCebYzE3Q== osadmin@vbook"
  }
}

resource "yandex_compute_disk" "hekke-disk" {
  name     = "hekke-disk"
  type     = "network-hdd"
  zone     = var.prefered_zones[0]
  size     = 16
//Ubuntu 22.04 LTS OS Login
//image_id = "fd813vofdafcjauqlsqv"
//Debian 12 v20240129
  image_id = "fd8lfos8m26g6pvkjq91"
  labels   = "${var.labels}"
}

resource "yandex_vpc_address" "hekke-ip" {
  name      = "hekke-ip"
  external_ipv4_address {
    zone_id = var.prefered_zones[0]
  }
//The dns_record block supports:
//fqdn - (Required) FQDN for record to address
//dns_zone_id - (Required) DNS zone id to create record at.
//ttl - (Optional) TTL of DNS record
//ptr - (Optional) If PTR record is needed
  dns_record {
    fqdn        = "hekke.${var.project_domain_zone}."
    dns_zone_id = "${yandex_dns_zone.project_domain.id}"
    ttl         = 300
    ptr         = true
  }
  labels    = "${var.labels}"
}

resource "yandex_dns_recordset" "hekke-project_domain" {
  zone_id = "${yandex_dns_zone.project_domain.id}"
  name    = "hekke.${var.project_domain_zone}."
  type    = "A"
  ttl     = 300
  data    = ["${yandex_vpc_address.hekke-ip.external_ipv4_address[0].address}"]
}
