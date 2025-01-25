provider "nomad" {
  address = "https://100.78.218.70:4648"
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

