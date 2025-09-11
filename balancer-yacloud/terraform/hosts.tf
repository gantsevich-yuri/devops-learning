resource "local_file" "ansible_inventory" {
  filename = "../ansible/hosts.ini"
  content  = <<EOT
[VMs]
vm-a ansible_host=${yandex_compute_instance.vm["vm-a"].network_interface.0.nat_ip_address} ansible_user=fox ansible_ssh_private_key_file=~/.ssh/yacloud-work
vm-b ansible_host=${yandex_compute_instance.vm["vm-b"].network_interface.0.nat_ip_address} ansible_user=fox ansible_ssh_private_key_file=~/.ssh/yacloud-work
EOT
}