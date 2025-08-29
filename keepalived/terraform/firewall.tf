resource "yandex_vpc_security_group" "WAN" {
  name       = "wan"
  network_id = yandex_vpc_network.devnet.id

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "web"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "ANY"
    description    = "Any local traffic"
    v4_cidr_blocks = yandex_vpc_subnet.devsubnet_1.v4_cidr_blocks
  }

  egress {
    protocol       = "ANY"
    description    = "from vm"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}