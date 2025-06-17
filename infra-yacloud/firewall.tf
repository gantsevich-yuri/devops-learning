resource "yandex_vpc_security_group" "ALB" {
  name        = "alb"
  network_id  = yandex_vpc_network.devnet.id

  ingress {
    protocol       = "TCP"
    description    = "to bastion"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "from bastion"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}


resource "yandex_vpc_security_group" "LAN" {
  name        = "lan"
  network_id  = yandex_vpc_network.devnet.id

  ingress {
    protocol       = "TCP"
    description    = "lan traffic"
    v4_cidr_blocks = ["10.10.0.0/23"]
    from_port      = 0
    to_port        = 65535
  }

  egress {
    protocol       = "ANY"
    description    = "from lan"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "WEB" {
  name        = "web"
  network_id  = yandex_vpc_network.devnet.id

  ingress {
    protocol       = "TCP"
    description    = "http traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "https traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
}