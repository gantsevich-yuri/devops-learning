resource "docker_network" "my_net" {
  name = "my_net"
}

resource "docker_image" "nginx" {
  name = var.nginx
  keep_locally = true
}

resource "docker_container" "nginx" {
  name = "nginx-v1.27.5"
  image = docker_image.nginx.image_id
  ports {
    external = 8888
    internal = 80
  }
  networks_advanced {
    name = docker_network.my_net.name
  }
}

resource "docker_image" "mysql" {
  name = var.mysql
  keep_locally = true
}

resource "docker_container" "mysql" {
  name = "mysql-v9.3.0"
  image = docker_image.mysql.image_id
  env = [
    "MYSQL_ROOT_PASSWORD=password",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=admin",
    "MYSQL_PASSWORD=password"
  ]
  networks_advanced {
    name = docker_network.my_net.name
  }
}

resource "docker_image" "wordpress" {
  name = var.wordpress
  keep_locally = true
}

resource "docker_container" "wordpress" {
  name = "wordpress-v6.8.1"
  image = docker_image.wordpress.image_id
  ports {
    external = 80
    internal = 80
  }
  env = [
    "MARIADB_HOST=mysql-v9.3.0",
    "MARIADB_PORT_NUMBER=3306",
    "WORDPRESS_DATABASE_NAME=wordpress",
    "WORDPRESS_DATABASE_USER=admin",
    "WORDPRESS_DATABASE_PASSWORD=password"
  ]
  networks_advanced {
    name = docker_network.my_net.name
  }
  depends_on = [docker_container.mysql]
}
