# Get information about existing Compute Image
data "yandex_compute_image" "dev_image" {
  family = "ubuntu-2204-lts"
}

# VM Bastion
resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

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
    subnet_id          = yandex_vpc_subnet.pubsubnet_1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.BASTION.id, yandex_vpc_security_group.LAN.id]
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
  }

  scheduling_policy { preemptible = true }
}

# VM-1 Master Node k3s
resource "yandex_compute_instance" "master" {
  name        = "master"
  hostname    = "master"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
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
    subnet_id          = yandex_vpc_subnet.privsubnet_1.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
  }

  scheduling_policy { preemptible = true }
}

# VM-2 Worker Node k3s
resource "yandex_compute_instance" "worker" {
  name        = "worker"
  hostname    = "worker"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

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
    subnet_id          = yandex_vpc_subnet.privsubnet_2.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
  }

  scheduling_policy { preemptible = true }
}