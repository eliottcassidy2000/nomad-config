provider "nomad" {
  address = "https://your-nomad-server:4646"
  token   = var.nomad_token
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


variable "nomad_token" {}

