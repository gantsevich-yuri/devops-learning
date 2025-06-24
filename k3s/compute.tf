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
    subnet_id          = yandex_vpc_subnet.k3ssubnet_1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.BASTION.id,yandex_vpc_security_group.LAN.id]
  }
  
  metadata = {
    user-data = <<EOF
Content-Type: multipart/mixed; boundary="==XYZ="
MIME-Version: 1.0

--==XYZ==
Content-Type: text/cloud-config; charset="us-ascii"

#cloud-config
users:
  - name: k3s
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPOed+sy3bqMgsKU8ilo+eN289OHlLUM1/xcQ2Ti9eU/ yuri@ubuntu-work

--==XYZ==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
apt update -y
apt install -y iptables-persistent
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -s 0.0.0.0/0 -j MASQUERADE
netfilter-persistent save
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

--==XYZ==--
EOF
  }

  scheduling_policy { preemptible = true }
}

# VM-1 Master Node k3s
resource "yandex_compute_instance" "master" {
  name        = "master"
  hostname    = "master"
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
    subnet_id          = yandex_vpc_subnet.k3ssubnet_1.id
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
    subnet_id          = yandex_vpc_subnet.k3ssubnet_2.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id]
  }
  
  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = "1"
  }
  
  scheduling_policy { preemptible = true }
}