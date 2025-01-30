job "weed-master" {
  datacenters = ["dc1"]
  group "master" {
    count = 1
    network {
      port "master" {
        static = 9333
      }
    }
    task "master" {
      driver = "docker"

      config {
        image = "chrislusf/seaweedfs:latest"
        args = ["master"]
        ports = ["master"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}

