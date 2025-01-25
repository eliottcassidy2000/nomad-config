job "monad-forwarder" {
  datacenters = ["dc1"] # Replace with your datacenter name(s)
  type        = "system" # Ensures it runs on every worker

  group "monad-forwarder" {
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
        source      = "https://github.com/eliottcassidy2000/monad-forwarder/releases/download/v0.1.1/monad-forwarder_0.1.1_linux_arm64.tar.gz"
        destination = "/tmp/file.tar.gz"
      }

      resources {
        cpu    = 100 # Adjust CPU as needed
        memory = 128 # Adjust memory as needed
      }

      service {
        name = "monad-forwarder"
        port = "http"

        check {
          name     = "http health check"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      # Expose the HTTP port
      network {
        port "http" {
          static = 4646 # Replace with your desired port
        }
      }
    }
  }
}
