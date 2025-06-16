variable "nginx" {
  type = string
  default = "nginx:1.27.5"
}

variable "mysql" {
  type = string
  default = "bitnami/mysql:9.3.0"
}

variable "wordpress" {
  type = string
  default = "bitnami/wordpress:6.8.1"
}