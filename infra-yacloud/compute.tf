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
    subnet_id          = yandex_vpc_subnet.devsubnet_1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.BASTION.id,yandex_vpc_security_group.LAN.id]
  }
  
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
  }

  scheduling_policy { preemptible = true }
}

# VM web-1
resource "yandex_compute_instance" "web-1" {
  name        = "web-1"
  hostname    = "web-1"
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
    subnet_id          = yandex_vpc_subnet.devsubnet_1.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.WEB.id]
  }
  
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
  }
  
  scheduling_policy { preemptible = true }
}

# VM web-2
resource "yandex_compute_instance" "web-2" {
  name        = "web-2"
  hostname    = "web-2"
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
    subnet_id          = yandex_vpc_subnet.devsubnet_2.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.WEB.id]
  }
  
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
  }
  
  scheduling_policy { preemptible = true }
}

# VM db
resource "yandex_compute_instance" "mysql" {
  name        = "mysql"
  hostname    = "mysql"
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
    subnet_id          = yandex_vpc_subnet.devsubnet_1.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }
  
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
  }
  
  scheduling_policy { preemptible = true }
}