# Create VPC Network
resource "yandex_vpc_network" "k3s" {
  name = "devnet"
}

# Create VPC Subnet 1
resource "yandex_vpc_subnet" "k3ssubnet_1" {
  v4_cidr_blocks = ["10.0.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k3s.id
  route_table_id = yandex_vpc_route_table.k3sroute.id
}

# Create VPC Subnet 2
resource "yandex_vpc_subnet" "k3ssubnet_2" {
  v4_cidr_blocks = ["10.0.20.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k3s.id
  route_table_id = yandex_vpc_route_table.k3sroute.id
}

# Create VPC Route Table
resource "yandex_vpc_route_table" "k3sroute" {
  name = "devroute"
  network_id = yandex_vpc_network.k3s.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.bastion.network_interface.0.ip_address
  }
}