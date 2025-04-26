job "mysql" {
  datacenters = ["dc1"]
  type = "service"

  group "mysql" {
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
            size = 10000000000 # size in bytes
          }
        }
      }
      resources {
        cpu    = 1000
        memory = 4096  
      }
      env {
        # set a real root password (or use one of the other allowed vars)
        # MYSQL_RANDOM_ROOT_PASSWORD = "yes"
        MYSQL_ROOT_PASSWORD = "SuperSecret123"
        # MYSQL_DATABASE      = "myappdb"       # optional
        # MYSQL_USER          = "appuser"       # optional
        # MYSQL_PASSWORD      = "AppPassw0rd!"  # optional
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
