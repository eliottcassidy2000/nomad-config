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
          "-master", "seaweed_master.service.consul:9333"
        ]
        ports = ["filer"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}

