job "mysql" {
  datacenters = ["dc1"] # Replace with your datacenter name(s)
  type = "service"

  group "mysql" {
    network {
      port "http" {
        to = 80
      }
    }
    task "myaql" {
      driver = "docker"

      config {
        image  = "nginx:latest"
        ports = ["http"]
      }

      service {
        name = "mysql-test"
        port = "http"
        provider = "nomad"

        check {
          name     = "http health check"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
