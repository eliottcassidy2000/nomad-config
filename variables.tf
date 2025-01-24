variable "nomad_token" {
  description = "Nomad ACL token"
  type        = string
}

variable "job_name" {
  description = "Name of the job"
  type        = string
}

variable "datacenter" {
  description = "Nomad datacenter"
  type        = string
  default     = "dc1"
}
