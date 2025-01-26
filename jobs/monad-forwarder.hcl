job "monad-forwarder" {
  datacenters = ["dc1"] # Replace with your datacenter name(s)
  type = "system"

  group "monad-forwarder" {

    network {
      port "http" {
        static = 4645 # Use static port 4645
      }
    }
    task "monad-forwarder" {
      driver = "exec" # Use "exec" since you are running a binary

      config {
        command = "/bin/bash"
        args = [
          "-c",
          "tar -xzvf /tmp/file.tar.gz -C /tmp && chmod +x /tmp/monad-forwarder && /tmp/monad-forwarder"
        ]
      }

      artifact {
        source      = "https://github.com/eliottcassidy2000/monad-forwarder/releases/download/v0.2.1/monad-forwarder_0.2.1_linux_arm64.tar.gz"
        destination = "/tmp/file.tar.gz"
      }

      resources {
        cpu    = 100 # Adjust CPU as needed
        memory = 128 # Adjust memory as needed
      }

      constraint {
        attribute = "${node.class}"
        value     = "client"
      }

      service {
        name = "monad-forwarder"
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
