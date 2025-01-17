job "go-program" {
  datacenters = ["dc1"]

  group "go-group" {
    count = 1

    task "run-go-binary" {
      driver = "exec"

      config {
        command = "/bin/sh"
        args = [
          "-c",
          "curl -L -o /bin/my-program https://github.com/your-username/your-repo/releases/latest/download/my-program && " +
          "chmod +x /bin/my-program && /bin/my-program"
        ]
      }

      resources {
        cpu    = 500
        memory = 256
      }

      restart {
        attempts = 2
        interval = "5m"
        delay    = "30s"
        mode     = "fail"
      }
    }
  }
}

