job "docker-test" {
  datacenters = ["dc1"]
  type = "service"

  group "docker-test" {
    network {
      port "http" {
        to = 8085
      }
    }
    task "docker-test" {
      driver = "docker"

      config {
        image  = "ghcr.io/eliottcassidy2000/stream-forward:0.0.3"
        ports = ["http"]
      }

      service {
        name = "docker-test"
        port = "http"
        provider = "nomad"

        check {
          name     = "http health check"
          type     = "http"
          path     = "/latest/stream-forward/amd64/linux"
          interval = "80s"
          timeout  = "2s"
        }
      }
    }
  }
}
