resource "yandex_vpc_security_group" "BASTION" {
  name       = "bastion"
  network_id = yandex_vpc_network.k3snet.id

  ingress {
    protocol       = "TCP"
    description    = "to bastion"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
}

resource "yandex_vpc_security_group" "LAN" {
  name       = "lan"
  network_id = yandex_vpc_network.k3snet.id

  ingress {
    protocol       = "ANY"
    description    = "lan traffic"
    v4_cidr_blocks = ["10.0.0.0/16"]
  }
}
