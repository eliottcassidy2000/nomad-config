job "weed-volume" {
  datacenters = ["dc1"]
  group "volume" {
    count = 1
    network {
      port "volume" {
        static = 8080
      }
    }

    task "volume" {
      driver = "docker"

      config {
        image = "chrislusf/seaweedfs:latest"
        args = [
          "volume"
        ]
        ports = ["volume"]
      }

      resources {
        cpu    = 500
        memory = 512
      }

      service {
        name = "weed-volume"
        port = "volume"
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

