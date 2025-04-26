job "mysql" {
  datacenters = ["dc1"]
  type = "service"

  group "mysql" {
    volume "mysql-data" {
      type      = "host"
      read_only = false

      config {
        path = "/opt/nomad/mysql"   # path on the client machine
      }
    }
    network {
      port "http" {
        to = 80
      }
    }
    task "mysql" {
      driver = "docker"

      config {
        image = "mysql:8"
        ports = ["db"]
        volumes = [
          "local/mysql-data:/var/lib/mysql",  # host volume to persist data
        ]
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
