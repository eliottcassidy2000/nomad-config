job "weed-filer" {
  datacenters = ["dc1"]
  group "filer" {
    count = 1
    network {
      port "filer" {
        static = 8888
      }
    }
    task "filer" {
      driver = "docker"

      config {
        image = "chrislusf/seaweedfs:latest"
        args = [
          "filer",
          "-master", "127.0.0.1:4645/weed-master"
        ]
        ports = ["filer"]
      }

      resources {
        cpu    = 500
        memory = 256
      }

      service {
        name = "weed-filer"
        port = "filer"
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

