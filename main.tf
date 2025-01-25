provider "nomad" {
  address = "https://bigo-server-oracle.tail800b49.ts.net/"
}

resource "nomad_job" "weed-volume" {
  jobspec = file("./jobs/weed-volume.hcl")
}

resource "nomad_job" "weed-server" {
  jobspec = file("./jobs/weed-server.hcl")
}

resource "nomad_job" "weed-master" {
  jobspec = file("./jobs/weed-master.hcl")
}

resource "nomad_job" "run-go-binary" {
  jobspec = file("./jobs/run-go-binary.hcl")
}

resource "nomad_job" "monad-forwarder" {
  jobspec = file("./jobs/monad-forwarder.hcl")
}

