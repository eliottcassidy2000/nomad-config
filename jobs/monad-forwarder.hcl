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
        command = "local/monad-forwarder"
      }

      artifact {
        source      = "https://github.com/eliottcassidy2000/monad-forwarder/releases/download/v0.2.5/monad-forwarder_0.2.5_linux_${attr.cpu.arch}.tar.gz"
      }

      resources {
        cpu    = 100 # Adjust CPU as needed
        memory = 128 # Adjust memory as needed
      }

      template {
        data = <<EOH
NOMAD_TOKEN="{{with nomadVar "nomad/jobs"}}{{.NOMAD_ROOT_TOKEN}}{{end}}"
EOH
        destination = "secrets/file.env"
        env         = true
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
