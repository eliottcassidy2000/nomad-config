job "monad-forwarder" {
  datacenters = ["dc1"]
  type        = "system"

  group "monad-forwarder" {

    # Mount host /tmp so that the tsnet state directory persists between job restarts
    volume "tmp" {
      type      = "host"
      source    = "tmp"
      read_only = false
    }

    task "monad-forwarder" {
      driver = "exec"

      volume_mount {
        volume      = "tmp"
        destination = "/tmp"
      }

      config {
        command = "local/monad-forwarder"
      }

      artifact {
        #source      = "https://docker-test-docker-test0-7/latest/monad-forwarder"
        source      = "https://github.com/eliottcassidy2000/monad-forwarder/releases/download/0.0.3/monad-forwarder_0.0.3_linux_${attr.cpu.arch}.tar.gz"
      }

      resources {
        cpu    = 100
        memory = 256
      }

      template {
        data = <<EOH
NOMAD_TOKEN="{{with nomadVar "nomad/jobs"}}{{.NOMAD_ROOT_TOKEN}}{{end}}"
TS_API_KEY="{{with nomadVar "nomad/jobs"}}{{.TS_API_KEY}}{{end}}"
EOH
        destination = "secrets/file.env"
        env         = true
      }

      # Set the TMPDIR to /tmp/tsnet so your Go code uses it as the server Dir
      env {
        key   = "TMPDIR"
        value = "/tmp"
      }

    }
  }
}
