# Create VPC Network
resource "yandex_vpc_network" "k3snet" {
  name = "k3snet"
}

# Create VPC Public Subnet 1
resource "yandex_vpc_subnet" "pubsubnet_1" {
  v4_cidr_blocks = ["10.0.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k3snet.id
}
# Create VPC Private Subnet 1
resource "yandex_vpc_subnet" "privsubnet_1" {
  v4_cidr_blocks = ["10.0.11.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k3snet.id
  #route_table_id = yandex_vpc_route_table.k3sroute.id
}

# Create VPC Private Subnet 2
resource "yandex_vpc_subnet" "privsubnet_2" {
  v4_cidr_blocks = ["10.0.21.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k3snet.id
  #route_table_id = yandex_vpc_route_table.k3sroute.id
}

# Create VPC Route Table
resource "yandex_vpc_route_table" "k3sroute" {
  name       = "devroute"
  network_id = yandex_vpc_network.k3snet.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.bastion.network_interface.0.ip_address
  }
}