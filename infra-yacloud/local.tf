resource "local_file" "invenory" {
  content  = <<-ABC
  [bastion]
  ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}

  [webservers]
  ${yandex_compute_instance.web-1.network_interface.0.ip_address}
  ${yandex_compute_instance.web-2.network_interface.0.ip_address}

  [webservers:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q fox@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'
  ABC
  filename = file("./hosts.ini")
}