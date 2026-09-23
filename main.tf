resource "docker_image" "nginx" {
  name = "nginx:latest"
}
resource "docker_image" "node" {
  name = "node:20"
}
resource "docker_image" "postgres" {
  name = "postgres:16"
}
resource "docker_container" "frontend" {
  name = "web-${var.environment}"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = var.frontend_port
  }
}
resource "docker_container" "backend" {

  name = "api-${var.environment}"

  image = docker_image.node.image_id
  command = [
    "node",
    "-e",
    "require('http').createServer((req,res)=>res.end('Backend funcionando')).listen(3000)"
  ]
  ports {
    internal = 3000
    external = var.backend_port
  }
}
resource "docker_container" "database" {
  name = "bd-${var.environment}"
  image = docker_image.postgres.image_id
  env = [
    "POSTGRES_PASSWORD=123456",
    "POSTGRES_DB=app"
  ]
  ports {
    internal = 5432
    external = var.db_port
  }
}