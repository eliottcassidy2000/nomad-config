terraform {
  backend "s3" {
    bucket = "skrt"
    key    = "nomad/terraform.tfstate"
    region = "us-east-2"
  }
}