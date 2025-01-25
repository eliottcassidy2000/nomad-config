job "weed-volume" {
  datacenters = ["dc1"]
  group "volume" {
    count = 2 # Adjust for more nodes

    task "volume" {
      driver = "docker"

      config {
        image = "chrislusf/seaweedfs:latest"
        args = [
          "volume",
          "-max", "5",
          "-mserver", "seaweed_master.service.consul:9333"
        ]
        ports = ["volume"]
      }

      resources {
        cpu    = 500
        memory = 512
        network {
          port "volume" {
            static = 8080
          }
        }
      }
    }
  }
}

