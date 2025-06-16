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
