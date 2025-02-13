provider "nomad" {
  address = "https://bigo-server-oracle.tail800b49.ts.net/"
  # address = "http://100.78.218.70:4646"
}

resource "nomad_job" "monad-forwarder" {
  jobspec = file("./jobs/monad-forwarder.hcl")
}

resource "nomad_job" "docker-test" {
  jobspec = file("./jobs/docker-test.hcl")
}


resource "nomad_job" "hello-world" {
  jobspec = file("./jobs/hello-world.hcl")
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