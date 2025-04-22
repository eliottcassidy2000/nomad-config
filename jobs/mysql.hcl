job "mysql" {
  datacenters = ["dc1"]

  group "db" {
    volume "mysql_data" {
      type = "host"

      config {
        source      = "/opt/nomad-volumes/mysql_data"
        read_only   = false
      }
    }

    task "mysql" {
      driver = "docker"

      config {
        image = "mysql:8"
        ports = ["db"]

        volumes = [
          "nomad/mysql_data:/var/lib/mysql",
        ]
      }

      volume_mount {
        volume      = "mysql_data"
        destination = "/var/lib/mysql"
        read_only   = false
      }

      env {
        MYSQL_ROOT_PASSWORD = "supersecret"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
