job "mysql" {
  datacenters = ["dc1"]
  type = "service"

  group "mysql" {
  #   volume "tmp" {
  #     type      = "host"
  #     source    = "tmp"
  #     read_only = false
  #   }
    network {
      port "mysql" {
        to = 3306
      }
    }
    task "mysql" {
      driver = "docker"

      config {
        image = "mysql:8"
        ports = ["mysql"]
        mount {
          type = "tmpfs"
          target = "/var/lib/mysql"
          readonly = false
          tmpfs_options {
            size = 100000000 # size in bytes
          }
        }
      }

      service {
        name = "mysql-test"
        port = "mysql"
        provider = "nomad"

        check {
          name     = "mysql http health check"
          type     = "http"
          path     = "/"
          interval = "30s"
          timeout  = "2s"
        }
      }
    }
  }
}
