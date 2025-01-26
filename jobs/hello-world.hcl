job "hello-world" {
  datacenters = ["dc1"]

  group "web" {
    count = 1

    network {
        port "http" {
        to = 8088
        }
    }

    task "hello-world" {
      driver = "docker"

      config {
        image = "python:3.9-slim"
        command = "python3"
        args = ["-m", "http.server", "8088"]
        ports = ["http"]
      }

      resources {
        cpu    = 100 # MHz
        memory = 128 # MB
      }

      service {
        name = "hello-world"
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