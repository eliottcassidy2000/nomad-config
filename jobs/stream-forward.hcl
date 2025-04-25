job "stream-forward" {
  datacenters = ["dc1"]
  type        = "system"

  group "stream-forward" {

    task "stream-forward" {
      driver = "exec"

      volume_mount {
        volume      = "tmp"
        destination = "/tmp"
      }

      config {
        command = "local/stream-forward"
      }

      artifact {
        source      = "https://github.com/eliottcassidy2000/stream-forward/releases/download/0.0.0/stream-forward_0.0.0_linux_${attr.cpu.arch}.tar.gz"
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

    }
  }
}
