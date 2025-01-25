provider "nomad" {
  address = "https://bigo-server-oracle.tail800b49.ts.net/"
}

resource "nomad_job" "monad-forwarder" {
  jobspec = file("./jobs/monad-forwarder.hcl")
}

