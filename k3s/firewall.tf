resource "yandex_vpc_security_group" "BASTION" {
  name       = "bastion"
  network_id = yandex_vpc_network.k3s_net.id

  ingress {
    protocol       = "TCP"
    description    = "to bastion"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "to ALL"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

resource "yandex_vpc_security_group" "LAN" {
  name       = "lan"
  network_id = yandex_vpc_network.k3s_net.id

  ingress {
    protocol       = "ANY"
    description    = "lan traffic"
    v4_cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    description    = "to ALL"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
