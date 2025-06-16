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
}

resource "docker_image" "wordpress" {
  name = var.wordpress
  keep_locally = true
}

resource "docker_container" "wordpress" {
  name = "wordpress-v6.8.1"
  image = docker_image.wordpress.image_id
  ports {
    external = 8899
    internal = 80
  }
  env = [
 #   "WORDPRESS_DB_HOST=mysql:3306",
 #   "WORDPRESS_DB_USER=admin",
 #   "WORDPRESS_DB_PASSWORD=password",
 #   "WORDPRESS_DB_NAME=wordpress"
     "ALLOW_EMPTY_PASSWORD=yes"
  ]
  depends_on = [docker_container.mysql]
}
