# Create VPC Network
resource "yandex_vpc_network" "devnet" {
  name = "devnet"
}

# Create VPC Subnet 1
resource "yandex_vpc_subnet" "devsubnet_1" {
  v4_cidr_blocks = ["10.10.0.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.devnet.id
  route_table_id = yandex_vpc_network.devroute.id
}

# Create VPC Subnet 2
resource "yandex_vpc_subnet" "devsubnet_2" {
  v4_cidr_blocks = ["10.10.1.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.devnet.id
  route_table_id = yandex_vpc_network.devroute.id
}

# Create VPC Route Table
resource "yandex_vpc_route_table" "devroute" {
  name = "devroute"
  network_id = yandex_vpc_network.devnet.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.devnet_natgw.id
  }
}

# Create VPC NAT Gateway
resource "yandex_vpc_gateway" "devnet_natgw" {
  name = "devnet_natgw"
  shared_egress_gateway {}
}