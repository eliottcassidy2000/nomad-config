job "mysql" {
  datacenters = ["dc1"]
  type = "service"

  group "mysql" {
    count = 1

    network {
      port "db" {
        to = 3306
      }
    }

    volume "mysql_data" {
      type      = "host"
      source    = "mysql_data"
      read_only = false
    }

    task "mysql" {
      driver = "docker"

      config {
        image = "mysql:8.0"
        ports = ["db"]
        env = {
          MYSQL_ROOT_PASSWORD = "rootpassword"
          MYSQL_DATABASE = "mydb"
        }
      }

      volume_mount {
        volume      = "mysql_data"
        destination = "/var/lib/mysql"
        read_only   = false
      }

      resources {
        cpu    = 500
        memory = 512
      }

      service {
        name = "mysql"
        port = "db"

        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
