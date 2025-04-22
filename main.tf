provider "nomad" {
  address = "https://bigo-server-oracle.tail800b49.ts.net/"
  # address = "http://100.78.218.70:4646"
}

resource "nomad_dynamic_host_volume" "mysql_data" {
  # A name used in Nomad for referencing this volume
  name      = "mysql_data"
  plugin_id = "host" # This is always "host" for host volumes

  config {
    # This is where the volume will be created on the host
    # Nomad client must have permission to write to this path
    path = "/opt/nomad/volumes/mysql"
  }

  # Optional: restrict to certain nodes
  constraints {
    attribute = "${node.unique.name}"
    operator  = "regexp"
    value     = ".*" # all nodes
  }
}

#resource "nomad_job" "monad-forwarder" {
#  jobspec = file("./jobs/monad-forwarder.hcl")
#}

resource "nomad_job" "docker-test" {
  jobspec = file("./jobs/docker-test.hcl")
}


resource "nomad_job" "hello-world" {
  jobspec = file("./jobs/hello-world.hcl")
}

resource "nomad_job" "mysql" {
  jobspec = file("./jobs/mysql.hcl")
}

# resource "nomad_job" "weed-master" {
#   jobspec = file("./jobs/weed-master.hcl")
# }

# resource "nomad_job" "weed-server" {
#   jobspec = file("./jobs/weed-server.hcl")
# }

# resource "nomad_job" "weed-mvolume" {
#   jobspec = file("./jobs/weed-volume.hcl")
# }
