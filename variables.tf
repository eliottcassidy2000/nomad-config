variable "nomad_token" {
  description = "Nomad ACL token"
  type        = string
  default     = "wrong_token"
}

variable "job_name" {
  description = "Name of the job"
  type        = string
  default     = "wrong_name"
}

variable "datacenter" {
  description = "Nomad datacenter"
  type        = string
  default     = "dc1"
}
