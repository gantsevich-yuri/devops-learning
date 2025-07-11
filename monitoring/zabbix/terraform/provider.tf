terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.142.0"
    }
  }
  required_version = ">=1.8.4"
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = file("~/.authorized_key_yacl_worker.json")
  zone                     = var.zone_id
}
