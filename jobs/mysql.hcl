job "mysql" {
  datacenters = ["dc1"]
  type = "service"

  # group "mysql" {
  #   volume "tmp" {
  #     type      = "host"
  #     source    = "tmp"
  #     read_only = false
  #   }
    network {
      port "http" {
        to = 80
      }
    }
    task "mysql" {
      driver = "docker"

      config {
        image = "mysql:8"
        ports = ["db"]
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
