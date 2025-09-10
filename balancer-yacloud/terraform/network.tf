# Create VPC Network
resource "yandex_vpc_network" "devnet" {
  name = "devnet"
}

# Create VPC Subnets
resource "yandex_vpc_subnet" "devsubnet" {
  for_each       = local.instances
  name           = "subnet-${each.key}"  
  network_id     = yandex_vpc_network.devnet.id
  v4_cidr_blocks = [each.value.cidr]
  zone           = each.value.zone
  route_table_id = yandex_vpc_route_table.devroute.id
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
  name = "devnet-natgw"
  shared_egress_gateway {}
}