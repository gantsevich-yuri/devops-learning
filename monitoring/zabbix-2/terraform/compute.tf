# Get information about existing Compute Image
data "yandex_compute_image" "dev_image" {
  family = "ubuntu-2204-lts"
}

# VM 1 (Zabbix Server and Zabbix client1)
resource "yandex_compute_instance" "vm1" {
  name        = "vm1"
  hostname    = "vm1"
  platform_id = "standard-v3"
  zone        = var.zone_id

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.dev_image.id
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.devsubnet_1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.WAN.id]
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
  }

  scheduling_policy { preemptible = true }
}

# VM2 Zabbix client2
resource "yandex_compute_instance" "vm2" {
  name        = "vm2"
  hostname    = "vm2"
  platform_id = "standard-v3"
  zone        = var.zone_id

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.dev_image.id
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.devsubnet_2.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.WAN.id]
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
  }

  scheduling_policy { preemptible = true }
}

