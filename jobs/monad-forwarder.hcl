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

      config {
        command = "local/monad-forwarder"

        # bind-mount the tsnet_state volume into each alloc
        mounts = [
          {
            type        = "volume"                # mount a Nomad volume
            source      = "tmp"          # the volume declared above
            destination = "tmp"    # inside the alloc’s sandbox
            read_only   = false
          },
        ]
      }

      artifact {
        source      = "https://github.com/eliottcassidy2000/monad-forwarder/releases/download/0.0.1/monad-forwarder_0.0.1_linux_${attr.cpu.arch}.tar.gz"
      }

      resources {
        cpu    = 100
        memory = 128
      }

      template {
        data = <<EOH
NOMAD_TOKEN="{{with nomadVar "nomad/jobs"}}{{.NOMAD_ROOT_TOKEN}}{{end}}"
TS_API_KEY="{{with nomadVar "nomad/jobs"}}{{.TS_API_KEY}}{{end}}"
EOH
        destination = "secrets/file.env"
        env         = true
      }

      # Set the TSNET_DIR to /tmp/tsnet so your Go code uses it as the server Dir
      env {
        key   = "TSNET_DIR"
        value = "/tmp/tsnet"
      }

    }
  }
}
