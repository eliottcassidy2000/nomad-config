provider "nomad" {
  address = "https://bigo-server-oracle.tail800b49.ts.net/"
}

resource "nomad_job" "monad-forwarder" {
  jobspec = file("./jobs/monad-forwarder.hcl")
}

resource "nomad_job" "docker-test" {
  jobspec = file("./jobs/docker-test.hcl")
}
