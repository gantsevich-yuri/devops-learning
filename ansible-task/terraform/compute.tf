data "yandex_compute_image" "dev_image" {
  family = "ubuntu-2204-lts"
}

data "template_file" "cloud_config" {
  template = file("${path.module}/cloud-init.tpl")
  vars = {
    ssh_key = file("/home/yuri/.ssh/yacloud_terraform.pub")
  }
}

resource "yandex_compute_instance" "vm1" {
  name        = "vm1"
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
    index     = 1
    subnet_id = yandex_vpc_subnet.devsubnet_1.id
  }

  metadata = {
    user-data          = data.template_file.cloud_config.rendered
    serial-port-enable = "1"
  }

  scheduling_policy { preemptible = true }
}




