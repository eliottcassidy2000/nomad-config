job "stream-forward" {
  datacenters = ["dc1"]
  type        = "service"

  group "stream-forward" {
    network {
      port "http" {
        to = 8085
      }
    }
    task "stream-forward" {
      driver = "exec"

      config {
        command = "local/stream-forward"
      }

      artifact {
        source      = "https://github.com/eliottcassidy2000/stream-forward/releases/download/0.0.1/stream-forward_0.0.1_linux_${attr.cpu.arch}.tar.gz"
      }

      resources {
        cpu    = 100
        memory = 256
      }
      # This below secrets are at least one uncessary
      template {
        data = <<EOH
NOMAD_TOKEN="{{with nomadVar "nomad/jobs"}}{{.NOMAD_ROOT_TOKEN}}{{end}}"
TS_API_KEY="{{with nomadVar "nomad/jobs"}}{{.TS_API_KEY}}{{end}}"
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
