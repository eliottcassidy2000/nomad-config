job "docker-test" {
  datacenters = ["dc1"] # Replace with your datacenter name(s)
  type = "service"

  group "docker-test" {
    network {
      port "http" {
        to = 80
      }
    }
    task "docker-test" {
      driver = "docker"

      config {
        image  = "ghcr.io/eliottcassidy2000/monad-forwarder:0.0.0"
        ports = ["http"]
      }

      service {
        name = "docker-test"
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
