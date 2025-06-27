# Create VPC Network
resource "yandex_vpc_network" "k3s_net" {
  name = "k3snet"
}

# Create VPC Public Subnet 1
resource "yandex_vpc_subnet" "pubsubnet_1" {
  v4_cidr_blocks = ["10.0.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k3s_net.id
}
# Create VPC Private Subnet 1
resource "yandex_vpc_subnet" "privsubnet_1" {
  v4_cidr_blocks = ["10.0.11.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k3s_net.id
  route_table_id = yandex_vpc_route_table.k3s_route.id
}

# Create VPC Private Subnet 2
resource "yandex_vpc_subnet" "privsubnet_2" {
  v4_cidr_blocks = ["10.0.21.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k3s_net.id
  route_table_id = yandex_vpc_route_table.k3s_route.id
}

# Create VPC Gateway
resource "yandex_vpc_gateway" "k3s_gw" {
  name = "k3gw"
  shared_egress_gateway {}
}

# Create VPC Route Table
resource "yandex_vpc_route_table" "k3s_route" {
  name       = "k3sroute"
  network_id = yandex_vpc_network.k3s_net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.k3s_gw.id
  }
}